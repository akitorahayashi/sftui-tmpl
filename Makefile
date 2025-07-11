# Makefile for TemplateApp iOS Project
# 
# Available targets:
#   make deps           - 依存関係をチェック
#   make build-debug    - デバッグビルド
#   make build-release  - リリースビルド
#   make build-test     - テスト用ビルド
#   make test-unit      - テスト用ビルド成果物を利用してユニットテストを実行
#   make test-ui        - テスト用ビルド成果物を利用してUIテストを実行
#   make test-all       - テスト用ビルド成果物を利用して全てのテストを実行
#   make archive        - リリース用アーカイブを作成

# === Configuration ===
OUTPUT_DIR := build
PROJECT_FILE := TemplateApp.xcodeproj
APP_SCHEME := TemplateApp
UNIT_TEST_SCHEME := TemplateAppTests
UI_TEST_SCHEME := TemplateAppUITests

# === Derived paths ===
ARCHIVE_PATH := $(OUTPUT_DIR)/archives/TemplateApp.xcarchive
UNIT_TEST_RESULTS := $(OUTPUT_DIR)/test-results/unit/TestResults.xcresult
UI_TEST_RESULTS := $(OUTPUT_DIR)/test-results/ui/TestResults.xcresult
DERIVED_DATA_PATH := $(OUTPUT_DIR)/test-results/DerivedData

# === Default target ===
.PHONY: test-all
test-all: find-artifacts test-unit test-ui
	@echo "✅ All tests completed."

# === Build for testing ===
.PHONY: build-test
build-test: find-simulator
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

# === Debug build ===
.PHONY: build-debug
build-debug: find-simulator
	@echo "🧹 Cleaning previous outputs..."
	@rm -rf $(OUTPUT_DIR)
	@mkdir -p $(OUTPUT_DIR)/debug
	@echo "✅ Previous outputs cleaned."
	@echo "🔨 Building debug..."
	@set -o pipefail && xcodebuild build \
		-project $(PROJECT_FILE) \
		-scheme $(APP_SCHEME) \
		-destination "platform=iOS Simulator,id=$(SIMULATOR_ID)" \
		-derivedDataPath $(OUTPUT_DIR)/debug/DerivedData \
		-configuration Debug \
		-skipMacroValidation \
		CODE_SIGNING_ALLOWED=NO \
		| xcbeautify
	@echo "✅ Debug build completed."

# === Release build ===
.PHONY: build-release
build-release: find-simulator
	@echo "🧹 Cleaning previous outputs..."
	@rm -rf $(OUTPUT_DIR)
	@mkdir -p $(OUTPUT_DIR)/release
	@echo "✅ Previous outputs cleaned."
	@echo "🔨 Building release..."
	@set -o pipefail && xcodebuild build \
		-project $(PROJECT_FILE) \
		-scheme $(APP_SCHEME) \
		-destination "platform=iOS Simulator,id=$(SIMULATOR_ID)" \
		-derivedDataPath $(OUTPUT_DIR)/release/DerivedData \
		-configuration Release \
		-skipMacroValidation \
		CODE_SIGNING_ALLOWED=NO \
		| xcbeautify
	@echo "✅ Release build completed."

# === Unit tests ===
.PHONY: test-unit
test-unit: find-simulator
	@echo "🧪 Running Unit Tests..."
	@rm -rf $(UNIT_TEST_RESULTS)
	@set -o pipefail && xcodebuild test-without-building \
		-project $(PROJECT_FILE) \
		-scheme $(UNIT_TEST_SCHEME) \
		-destination "platform=iOS Simulator,id=$(SIMULATOR_ID)" \
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
.PHONY: test-ui
test-ui: find-simulator
	@echo "🧪 Running UI Tests..."
	@rm -rf $(UI_TEST_RESULTS)
	@set -o pipefail && xcodebuild test-without-building \
		-project $(PROJECT_FILE) \
		-scheme $(UI_TEST_SCHEME) \
		-destination "platform=iOS Simulator,id=$(SIMULATOR_ID)" \
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

# === Dependencies check ===
.PHONY: deps
deps:
	@echo "🔍 Checking dependencies..."
	@command -v mint >/dev/null 2>&1 || { echo "❌ Error: Mint not installed. Please install: brew install mint"; exit 1; }
	@command -v xcbeautify >/dev/null 2>&1 || { echo "❌ Error: xcbeautify not installed. Please install: brew install xcbeautify"; exit 1; }
	@command -v jq >/dev/null 2>&1 || { echo "❌ Error: jq not installed. Please install: brew install jq"; exit 1; }
	@echo "✅ All required dependencies are available."

# === Find simulator ===
.PHONY: find-simulator
find-simulator:
	@echo "🔍 Finding simulator..."
	@chmod +x ./.github/scripts/find-simulator.sh
	$(eval SIMULATOR_ID := $(shell ./.github/scripts/find-simulator.sh))
	@if [ -z "$(SIMULATOR_ID)" ]; then \
		echo "❌ Error: Could not find a suitable simulator"; \
		exit 1; \
	fi
	@echo "✅ Using Simulator ID: $(SIMULATOR_ID)"

# === Find existing artifacts ===
.PHONY: find-artifacts
find-artifacts:
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
