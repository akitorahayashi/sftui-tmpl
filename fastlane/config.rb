
# fastlane/config.rb
# Fastlane configuration values

# === Project ===
PROJECT_PATH = "TemplateApp.xcodeproj"

# === Scheme Constants ===
SCHEMES = {
  app: "TemplateApp",
  unit_test: "TemplateAppTests",
  ui_test: "TemplateAppUITests",
  intg_test: "TemplateAppIntgTests"
}.freeze

# === Test Paths ===
BUILD_PATH = "build"
LOGS_PATH = "fastlane/logs"
TEST_LOGS_PATH = "#{LOGS_PATH}/test"
BUILD_LOGS_PATH = "#{LOGS_PATH}/build"

TEST_RESULTS_PATH = "#{BUILD_PATH}/test-results"
UNIT_TEST_RESULT_PATH = "#{TEST_RESULTS_PATH}/unit/TestResults.xcresult"
UI_TEST_RESULT_PATH = "#{TEST_RESULTS_PATH}/ui/TestResults.xcresult"
INTG_TEST_RESULT_PATH = "#{TEST_RESULTS_PATH}/intg/TestResults.xcresult"

# === Archive Paths ===
DEBUG_ARCHIVE_PATH = "fastlane/build/debug/archive/TemplateApp.xcarchive"
RELEASE_ARCHIVE_PATH = "fastlane/build/release/archive/TemplateApp.xcarchive"

# === Build DerivedData Paths ===
TEST_DERIVED_DATA_PATH = "fastlane/build/test-results/DerivedData"
DEBUG_BUILD_DERIVED_DATA_PATH = "fastlane/build/debug/archive/DerivedData"
RELEASE_BUILD_DERIVED_DATA_PATH = "fastlane/build/release/archive/DerivedData"

# === Configurations ===
CONFIGURATIONS = {
  debug: "Debug",
  release: "Release",
}.freeze

# === Export Methods ===
EXPORT_METHODS = {
  app_store: "app-store",
  ad_hoc: "ad-hoc",
  enterprise: "enterprise",
  development: "development"
}.freeze