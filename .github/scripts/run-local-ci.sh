#!/bin/bash
#
#   $ .github/scripts/run-local-ci.sh                # 全てのテスト・アーカイブを実行
#   $ .github/scripts/run-local-ci.sh --all-tests    # ユニットテストとUIテストのみ実行
#   $ .github/scripts/run-local-ci.sh --unit-test    # ユニットテストのみ実行
#   $ .github/scripts/run-local-ci.sh --ui-test      # UIテストのみ実行
#   $ .github/scripts/run-local-ci.sh --archive-only # アーカイブのみ実行
#   $ --test-without-building # 既存のビルド成果物を使用してテスト実行

set -euo pipefail

# === Configuration ===
OUTPUT_DIR="ci-outputs"
PROJECT_FILE="TemplateApp.xcodeproj"
APP_SCHEME="TemplateApp"
UNIT_TEST_SCHEME="TemplateAppTests"
UI_TEST_SCHEME="TemplateAppUITests"

# === Default Flags ===
run_unit_tests=false
run_ui_tests=false
run_archive=false
skip_build_for_testing=false

# === Argument Parsing ===
specific_action_requested=false
test_without_building_specified=false

while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --all-tests)
      run_unit_tests=true
      run_ui_tests=true
      run_archive=false
      specific_action_requested=true
      shift
      ;;
    --unit-test)
      run_unit_tests=true
      run_archive=false
      specific_action_requested=true
      shift
      ;;
    --ui-test)
      run_ui_tests=true
      run_archive=false
      specific_action_requested=true
      shift
      ;;
    --archive-only)
      run_unit_tests=false
      run_ui_tests=false
      run_archive=true
      specific_action_requested=true
      shift
      ;;
    --test-without-building)
      skip_build_for_testing=true
      test_without_building_specified=true
      specific_action_requested=true
      shift
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# --test-without-buildingが指定された場合の特別処理
if [ "$test_without_building_specified" = true ]; then
  # 他のテストフラグが指定されていない場合は、全テスト + アーカイブを実行
  if [ "$run_unit_tests" = false ] && [ "$run_ui_tests" = false ] && [ "$run_archive" = false ]; then
    run_unit_tests=true
    run_ui_tests=true
    run_archive=true
  fi
else
  # 特定のアクションが要求されなかった場合は、すべてを実行
  if [ "$specific_action_requested" = false ]; then
    run_unit_tests=true
    run_ui_tests=true
    run_archive=true
  fi
fi

# === Helper Functions ===
step() {
  echo ""
  echo "──────────────────────────────────────────────────────────────────────"
  echo "▶️  $1"
  echo "──────────────────────────────────────────────────────────────────────"
}

success() {
  echo "✅ $1"
}

fail() {
  echo "❌ Error: $1" >&2 # エラーを標準エラー出力へリダイレクト
  exit 1
}

# xcodeprojを必要に応じて生成する関数
ensure_project_file() {
  # プロジェクトファイルが存在しない場合は自動生成
  if [ ! -d "$PROJECT_FILE" ]; then
    step "Generating Xcode project using XcodeGen"
    mint run xcodegen || fail "XcodeGen によるプロジェクト生成に失敗しました。"
    success "Xcode project generated successfully."
  fi
}

# アーティファクト検索関数
find_existing_artifacts() {
  local search_paths=(
    "$OUTPUT_DIR/test-results/DerivedData"
    "DerivedData"
    "$HOME/Library/Developer/Xcode/DerivedData"
  )
  
  echo "既存のビルドアーティファクトを検索中..."
  
  for path in "${search_paths[@]}"; do
    if [ -d "$path" ]; then
      # findを使ってTemplateApp.appを検索
      if find "$path" -name "TemplateApp.app" -type d | head -1 | grep -q "TemplateApp.app"; then
        echo "Found existing build artifacts at: $path"
        # シンボリックリンクまたはコピーでアーティファクトを利用可能にする
        if [ "$path" != "$OUTPUT_DIR/test-results/DerivedData" ]; then
          echo "Linking artifacts to $OUTPUT_DIR/test-results/DerivedData"
          mkdir -p "$OUTPUT_DIR/test-results"
          ln -sfn "$path" "$OUTPUT_DIR/test-results/DerivedData"
        fi
        return 0
      fi
    fi
  done
  
  return 1
}

# === Main Script ===

# 前回の出力をクリーンアップ (ビルドをスキップしない場合のみ)
if [ "$skip_build_for_testing" = false ]; then
  step "Cleaning previous outputs"
  echo "Removing old $OUTPUT_DIR directory if it exists..."
  rm -rf "$OUTPUT_DIR"
  success "Previous outputs cleaned."
else
  step "Reusing existing build outputs"
  # ビルドせずにテストを実行する場合、アーティファクトを検索
  if [ "$run_unit_tests" = true ] || [ "$run_ui_tests" = true ]; then
      if ! find_existing_artifacts; then
          fail "Cannot run tests without building: No existing build artifacts found. Please run a full build first or remove --test-without-building flag."
      fi
      success "Found and configured existing build artifacts."
  fi
fi

# 必要なディレクトリを作成
echo "Creating directories..."
mkdir -p "$OUTPUT_DIR/test-results/unit" \
         "$OUTPUT_DIR/test-results/ui" \
         "$OUTPUT_DIR/production" \
         "$OUTPUT_DIR/production/archives"
success "Directories created under $OUTPUT_DIR."

# === Dependency Check ===
# 必要なツールの存在確認
step "Checking dependencies"

# mint の存在確認
if ! command -v mint &> /dev/null; then
    fail "Mint がインストールされていません。先に mint をインストールしてください。(brew install mint)"
fi

# xcbeautify の存在確認 (テストまたはアーカイブを実行する場合)
if [ "$run_unit_tests" = true ] || [ "$run_ui_tests" = true ] || [ "$run_archive" = true ]; then
    if ! command -v xcbeautify &> /dev/null; then
        fail "xcbeautify がインストールされていません。先に xcbeautify をインストールしてください。(brew install xcbeautify)"
    fi
fi

success "All required dependencies are available."

if [ "$run_unit_tests" = true ] || [ "$run_ui_tests" = true ]; then
  # テスト実行時にプロジェクトファイルを確認
  ensure_project_file
  step "Running Tests"

  # シミュレータを検索
  echo "Finding simulator..."
  FIND_SIMULATOR_SCRIPT="./.github/scripts/find-simulator.sh"

  # スクリプトが実行可能であることを確認
  if [ ! -x "$FIND_SIMULATOR_SCRIPT" ]; then
    echo "Making $FIND_SIMULATOR_SCRIPT executable..."
    chmod +x "$FIND_SIMULATOR_SCRIPT"
    if [ $? -ne 0 ]; then
        fail "Failed to make $FIND_SIMULATOR_SCRIPT executable."
    fi
  fi

  # スクリプトを実行し、IDと終了コードをキャプチャ
  # set -e を一時的に無効化してエラーコードを適切にキャプチャ
  set +e
  SIMULATOR_ID=$("$FIND_SIMULATOR_SCRIPT")
  SCRIPT_EXIT_CODE=$?
  set -e

  if [ $SCRIPT_EXIT_CODE -ne 0 ]; then
      fail "$FIND_SIMULATOR_SCRIPT failed with exit code $SCRIPT_EXIT_CODE."
  fi

  if [ -z "$SIMULATOR_ID" ]; then
    fail "Could not find a suitable simulator ($FIND_SIMULATOR_SCRIPT returned empty ID)."
  fi
  echo "Using Simulator ID: $SIMULATOR_ID"
  success "Simulator selected."

  # テスト用にビルド (スキップされていない場合)
  if [ "$skip_build_for_testing" = false ]; then
    echo "Building for testing..."
    set -o pipefail && xcodebuild build-for-testing \
      -project "$PROJECT_FILE" \
      -scheme "$APP_SCHEME" \
      -destination "platform=iOS Simulator,id=$SIMULATOR_ID" \
      -derivedDataPath "$OUTPUT_DIR/test-results/DerivedData" \
      -configuration Debug \
      -skipMacroValidation \
      CODE_SIGNING_ALLOWED=NO \
    | xcbeautify
    success "Build for testing completed."
  else
      echo "Skipping build for testing as requested (--test-without-building)."
      success "Using existing build artifacts."
  fi

  # Unitテストを実行
  if [ "$run_unit_tests" = true ]; then
    step "Running Unit Tests"
    # 古いテスト結果をクリーンアップ
    rm -rf "$OUTPUT_DIR/test-results/unit/TestResults.xcresult"
    echo "Running Xcode Unit Tests..."
    set -o pipefail && xcodebuild test-without-building \
      -project "$PROJECT_FILE" \
      -scheme "$UNIT_TEST_SCHEME" \
      -destination "platform=iOS Simulator,id=$SIMULATOR_ID" \
      -derivedDataPath "$OUTPUT_DIR/test-results/DerivedData" \
      -enableCodeCoverage NO \
      -resultBundlePath "$OUTPUT_DIR/test-results/unit/TestResults.xcresult" \
      CODE_SIGNING_ALLOWED=NO \
    | xcbeautify

    # Unitテスト結果バンドルの存在を確認
    echo "Verifying unit test results bundle..."
    if [ ! -d "$OUTPUT_DIR/test-results/unit/TestResults.xcresult" ]; then
      fail "Unit test result bundle not found at $OUTPUT_DIR/test-results/unit/TestResults.xcresult"
    fi
    success "Unit test result bundle found at $OUTPUT_DIR/test-results/unit/TestResults.xcresult"
  fi

  # UIテストを実行
  if [ "$run_ui_tests" = true ]; then
    step "Running UI Tests"
    # 古いテスト結果をクリーンアップ
    rm -rf "$OUTPUT_DIR/test-results/ui/TestResults.xcresult"
    echo "Running UI Tests..."
    set -o pipefail && xcodebuild test-without-building \
      -project "$PROJECT_FILE" \
      -scheme "$UI_TEST_SCHEME" \
      -destination "platform=iOS Simulator,id=$SIMULATOR_ID" \
      -derivedDataPath "$OUTPUT_DIR/test-results/DerivedData" \
      -enableCodeCoverage NO \
      -resultBundlePath "$OUTPUT_DIR/test-results/ui/TestResults.xcresult" \
      CODE_SIGNING_ALLOWED=NO \
    | xcbeautify

    # UIテスト結果バンドルの存在を確認
    echo "Verifying UI test results bundle..."
    if [ ! -d "$OUTPUT_DIR/test-results/ui/TestResults.xcresult" ]; then
      fail "UI test result bundle not found at $OUTPUT_DIR/test-results/ui/TestResults.xcresult"
    fi
    success "UI test result bundle found at $OUTPUT_DIR/test-results/ui/TestResults.xcresult"
  fi
fi

# --- Build for Production (Archive) ---
if [ "$run_archive" = true ]; then
  # アーカイブ実行時にプロジェクトファイルを確認
  ensure_project_file
  
  step "Building for Production (Unsigned)"

  # アーカイブビルド
  echo "Building archive..."
  set -o pipefail && xcodebuild \
    -project "$PROJECT_FILE" \
    -scheme "$APP_SCHEME" \
    -configuration Release \
    -destination "generic/platform=iOS Simulator" \
    -archivePath "$OUTPUT_DIR/production/archives/TemplateApp.xcarchive" \
    -derivedDataPath "$OUTPUT_DIR/production/DerivedData" \
    -skipMacroValidation \
    CODE_SIGNING_ALLOWED=NO \
    archive \
  | xcbeautify
  success "Archive build completed."

  # アーカイブ内容を検証
  echo "Verifying archive contents..."
  ARCHIVE_PATH="$OUTPUT_DIR/production/archives/TemplateApp.xcarchive"
  ARCHIVE_APP_PATH="$ARCHIVE_PATH/Products/Applications/$APP_SCHEME.app"
  if [ ! -d "$ARCHIVE_APP_PATH" ]; then
    echo "Error: '$APP_SCHEME.app' not found in expected archive location ($ARCHIVE_APP_PATH)."
    echo "Archive directory: $ARCHIVE_PATH"
    fail "Archive verification failed."
  fi
  success "Archive content verified."
fi

step "Local CI Check Completed Successfully!"