# Makefile for TemplateApp iOS Project
# 
# [ユーザー向けコマンド]
# --- Xcodeの操作 ---
#   make boot               - ローカルシミュレータ（iPhone 16 Pro）を起動
#   make run-debug          - デバッグビルドを作成し、ローカルシミュレータにインストール＆起動
#   make run-release        - リリースビルドを作成し、ローカルシミュレータにインストール＆起動
#   make clean-proj         - Xcodeプロジェクトのビルドフォルダをクリーン
#
# --- ビルド関連 ---
#   make build-test         - テスト用ビルド（テスト実行前に必須）
#   make archive            - リリース用アーカイブ作成
#
# --- テスト関連 ---
#   make unit-test          - ユニットテスト実行
#   make ui-test            - UIテスト実行
#   make test-all           - 全テスト一括実行
#
# [内部ワークフロー用コマンド]
#   make deps               - 依存関係チェック
#   make find-test-artifacts- テスト成果物探索
#
# === Configuration ===
OUTPUT_DIR := build
PROJECT_FILE := TemplateApp.xcodeproj
APP_SCHEME := TemplateApp
UNIT_TEST_SCHEME := TemplateAppTests
UI_TEST_SCHEME := TemplateAppUITests

# CI用にシミュレータを選ぶ関数
select-simulator = $(shell \
    xcrun simctl list devices available | \
    grep -A1 "iPhone" | grep -Eo "[A-F0-9-]{36}" | head -n 1 \
)


# === Derived paths ===
ARCHIVE_PATH := $(OUTPUT_DIR)/archives/TemplateApp.xcarchive
UNIT_TEST_RESULTS := $(OUTPUT_DIR)/test-results/unit/TestResults.xcresult
UI_TEST_RESULTS := $(OUTPUT_DIR)/test-results/ui/TestResults.xcresult
DERIVED_DATA_PATH := $(OUTPUT_DIR)/test-results/DerivedData

# === Local Simulator ===
LOCAL_SIMULATOR_NAME := iPhone 16 Pro
LOCAL_SIMULATOR_OS := 26.0
LOCAL_SIMULATOR_UDID := 5495CFE4-9EBC-45C5-8F85-37E0E143B3CC

# === App Bundle Identifier ===
APP_BUNDLE_ID := com.example.templateapp

# === Boot simulator ===
.PHONY: boot
boot:
	@echo "🚀 Booting local simulator: $(LOCAL_SIMULATOR_NAME) (OS: $(LOCAL_SIMULATOR_OS), UDID: $(LOCAL_SIMULATOR_UDID))"
	xcrun simctl boot $(LOCAL_SIMULATOR_UDID)
	open -a Simulator
	@echo "✅ Local simulator boot command executed."

.PHONY: run-debug
run-debug:
	@echo "Using Local Simulator: $(LOCAL_SIMULATOR_NAME) (OS: $(LOCAL_SIMULATOR_OS), UDID: $(LOCAL_SIMULATOR_UDID))"
	@echo "🧹 Cleaning previous outputs..."
	@rm -rf $(OUTPUT_DIR)
	@mkdir -p $(OUTPUT_DIR)/debug
	@echo "✅ Previous outputs cleaned."
	@echo "🔨 Building debug..."
	@set -o pipefail && xcodebuild build \
		-project $(PROJECT_FILE) \
		-scheme $(APP_SCHEME) \
		-destination "platform=iOS Simulator,id=$(LOCAL_SIMULATOR_UDID)" \
		-derivedDataPath $(OUTPUT_DIR)/debug/DerivedData \
		-configuration Debug \
		-skipMacroValidation \
		CODE_SIGNING_ALLOWED=NO \
		| xcbeautify
	@echo "✅ Debug build completed."
	@echo "📲 Installing debug build to simulator ($(LOCAL_SIMULATOR_NAME))..."
	xcrun simctl install $(LOCAL_SIMULATOR_UDID) $(OUTPUT_DIR)/debug/DerivedData/Build/Products/Debug-iphonesimulator/TemplateApp.app
	@echo "✅ Installed debug build."
	@echo "🚀 Launching app ($(APP_BUNDLE_ID)) on simulator ($(LOCAL_SIMULATOR_NAME))..."
	xcrun simctl launch $(LOCAL_SIMULATOR_UDID) $(APP_BUNDLE_ID)
	@echo "✅ App launched."

.PHONY: run-release
run-release:
	@echo "Using Local Simulator: $(LOCAL_SIMULATOR_NAME) (OS: $(LOCAL_SIMULATOR_OS), UDID: $(LOCAL_SIMULATOR_UDID))"
	@echo "🧹 Cleaning previous outputs..."
	@rm -rf $(OUTPUT_DIR)
	@mkdir -p $(OUTPUT_DIR)/release
	@echo "✅ Previous outputs cleaned."
	@echo "🔨 Building release..."
	@set -o pipefail && xcodebuild build \
		-project $(PROJECT_FILE) \
		-scheme $(APP_SCHEME) \
		-destination "platform=iOS Simulator,id=$(LOCAL_SIMULATOR_UDID)" \
		-derivedDataPath $(OUTPUT_DIR)/release/DerivedData \
		-configuration Release \
		-skipMacroValidation \
		CODE_SIGNING_ALLOWED=NO \
		| xcbeautify
	@echo "✅ Release build completed."
	@echo "📲 Installing release build to simulator ($(LOCAL_SIMULATOR_NAME))..."
	xcrun simctl install $(LOCAL_SIMULATOR_UDID) $(OUTPUT_DIR)/release/DerivedData/Build/Products/Release-iphonesimulator/TemplateApp.app
	@echo "✅ Installed release build."
	@echo "🚀 Launching app ($(APP_BUNDLE_ID)) on simulator ($(LOCAL_SIMULATOR_NAME))..."
	xcrun simctl launch $(LOCAL_SIMULATOR_UDID) $(APP_BUNDLE_ID)
	@echo "✅ App launched."

# === Build for testing ===
.PHONY: build-test
build-test:
ifeq ($(SIMULATOR_UDID),)
	$(eval SIMULATOR_ID := $(call select-simulator,$(APP_SCHEME)))
else
	$(eval SIMULATOR_ID := $(SIMULATOR_UDID))
endif
	@echo "Using Simulator UDID: $(SIMULATOR_ID)"
	@echo "🧹 Cleaning previous outputs..."
	@rm -rf $(OUTPUT_DIR)
	@mkdir -p $(OUTPUT_DIR)/test-results/unit $(OUTPUT_DIR)/test-results/ui $(OUTPUT_DIR)/archives
	@echo "✅ Previous outputs cleaned."
	@echo "🔨 Building for testing..."
	@set -o pipefail && xcodebuild build-for-testing \
		-project $(PROJECT_FILE) \
		-scheme $(APP_SCHEME) \
		-destination "platform=iOS Simulator,id=$(SIMULATOR_ID)" \
		-derivedDataPath $(DERIVED_DATA_PATH) \
		-configuration Debug \
		-skipMacroValidation \
		CODE_SIGNING_ALLOWED=NO \
		| xcbeautify
	@echo "✅ Build for testing completed."

# === Archive ===
.PHONY: archive
archive:
	@echo "🧹 Cleaning previous outputs..."
	@rm -rf $(OUTPUT_DIR)
	@mkdir -p $(OUTPUT_DIR)/archives
	@echo "✅ Previous outputs cleaned."
	@echo "📦 Building archive..."
	@set -o pipefail && xcodebuild \
		-project $(PROJECT_FILE) \
		-scheme $(APP_SCHEME) \
		-configuration Release \
		-destination "generic/platform=iOS Simulator" \
		-archivePath $(ARCHIVE_PATH) \
		-derivedDataPath $(OUTPUT_DIR)/archives/DerivedData \
		-skipMacroValidation \
		CODE_SIGNING_ALLOWED=NO \
		archive \
		| xcbeautify
	@echo "🔍 Verifying archive contents..."
	@ARCHIVE_APP_PATH="$(ARCHIVE_PATH)/Products/Applications/$(APP_SCHEME).app"; \
	if [ ! -d "$$ARCHIVE_APP_PATH" ]; then \
		echo "❌ Error: '$(APP_SCHEME).app' not found in expected archive location ($$ARCHIVE_APP_PATH)"; \
		echo "Archive directory: $(ARCHIVE_PATH)"; \
		exit 1; \
	fi
	@echo "✅ Archive build completed and verified."

# === Unit tests ===
.PHONY: unit-test
unit-test:
	$(eval SIMULATOR_RAW := $(call select-simulator,$(UNIT_TEST_SCHEME)))
	@echo "Using Simulator UDID: $(SIMULATOR_RAW)"
	@echo "🧪 Running Unit Tests..."
	@rm -rf $(UNIT_TEST_RESULTS)
	@set -o pipefail && xcodebuild test-without-building \
		-project $(PROJECT_FILE) \
		-scheme $(UNIT_TEST_SCHEME) \
		-destination "platform=iOS Simulator,id=$(word 1,$(subst |, ,$(SIMULATOR_RAW)))" \
		-derivedDataPath $(DERIVED_DATA_PATH) \
		-enableCodeCoverage NO \
		-resultBundlePath $(UNIT_TEST_RESULTS) \
		CODE_SIGNING_ALLOWED=NO \
		| xcbeautify
	@if [ ! -d "$(UNIT_TEST_RESULTS)" ]; then \
		echo "❌ Error: Unit test result bundle not found"; \
		exit 1; \
	fi
	@echo "✅ Unit tests completed. Results: $(UNIT_TEST_RESULTS)"

# === UI tests ===
.PHONY: ui-test
ui-test:
	$(eval SIMULATOR_RAW := $(call select-simulator,$(UI_TEST_SCHEME)))
	@echo "Using Simulator UDID: $(SIMULATOR_RAW)"
	@echo "🧪 Running UI Tests..."
	@rm -rf $(UI_TEST_RESULTS)
	@set -o pipefail && xcodebuild test-without-building \
		-project $(PROJECT_FILE) \
		-scheme $(UI_TEST_SCHEME) \
		-destination "platform=iOS Simulator,id=$(word 1,$(subst |, ,$(SIMULATOR_RAW)))" \
		-derivedDataPath $(DERIVED_DATA_PATH) \
		-enableCodeCoverage NO \
		-resultBundlePath $(UI_TEST_RESULTS) \
		CODE_SIGNING_ALLOWED=NO \
		| xcbeautify
	@if [ ! -d "$(UI_TEST_RESULTS)" ]; then \
		echo "❌ Error: UI test result bundle not found"; \
		exit 1; \
	fi
	@echo "✅ UI tests completed. Results: $(UI_TEST_RESULTS)"

# === All tests ===
.PHONY: test-all
test-all: find-test-artifacts unit-test ui-test
	@echo "✅ All tests completed."

# === Dependencies check ===
.PHONY: deps
deps:
	@echo "🔍 Checking dependencies..."
	@command -v mint >/dev/null 2>&1 || { echo "❌ Error: Mint not installed. Please install: brew install mint"; exit 1; }
	@command -v xcbeautify >/dev/null 2>&1 || { echo "❌ Error: xcbeautify not installed. Please install: brew install xcbeautify"; exit 1; }
	@echo "✅ All required dependencies are available."

# === Find existing artifacts ===
.PHONY: find-test-artifacts
find-test-artifacts:
	@echo "🔍 Finding existing build artifacts..."
	@FOUND=false; \
	for path in "$(OUTPUT_DIR)/test-results/DerivedData" "DerivedData" "$$HOME/Library/Developer/Xcode/DerivedData"; do \
		if [ -d "$$path" ] && find "$$path" -name "TemplateApp.app" -type d | head -1 | grep -q "TemplateApp.app"; then \
			echo "✅ Found existing build artifacts at: $$path"; \
			if [ "$$path" != "$(OUTPUT_DIR)/test-results/DerivedData" ]; then \
				echo "🔗 Linking artifacts to $(OUTPUT_DIR)/test-results/DerivedData"; \
				mkdir -p $(OUTPUT_DIR)/test-results; \
				ln -sfn "$$path" "$(OUTPUT_DIR)/test-results/DerivedData"; \
			fi; \
			FOUND=true; \
			break; \
		fi; \
	done; \
	if [ "$$FOUND" = false ]; then \
		echo "❌ Error: No existing build artifacts found. Please run 'make build-test' first."; \
		exit 1; \
	fi

.PHONY: clean-proj
clean-proj:
	@echo "🧹 Cleaning Xcode project build folder..."
	xcodebuild clean \
		-project $(PROJECT_FILE) \
		-scheme $(APP_SCHEME) \
		-destination "platform=iOS Simulator,id=$(LOCAL_SIMULATOR_UDID)"
	@echo "✅ Project build folder cleaned."
