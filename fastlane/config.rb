
# fastlane/config.rb
# Fastlane configuration values

# === Project ===
PROJECT_PATH = "TemplateApp.xcodeproj"

# === Scheme Constants ===
SCHEMES = {
  app: "TemplateApp",
  unit_test: "TemplateAppTests",
  ui_test: "TemplateAppUITests"
}.freeze

# === Test Paths ===
BUILD_PATH = "fastlane/build"
TEST_RESULTS_PATH = "#{BUILD_PATH}/test-results"
TEST_DERIVED_DATA_PATH = "#{BUILD_PATH}/test-results/DerivedData"
UNIT_TEST_RESULT_PATH = "#{TEST_RESULTS_PATH}/unit/TestResults.xcresult"
UI_TEST_RESULT_PATH = "#{TEST_RESULTS_PATH}/ui/TestResults.xcresult"

# === Archive Paths ===
DEBUG_EXPORT_BASE = "#{BUILD_PATH}/debug"
RELEASE_EXPORT_BASE = "#{BUILD_PATH}/release"
DEBUG_ARCHIVE_PATH = "#{DEBUG_EXPORT_BASE}/archive/TemplateApp.xcarchive"
RELEASE_ARCHIVE_PATH = "#{RELEASE_EXPORT_BASE}/archive/TemplateApp.xcarchive"

# === Build DerivedData Paths ===
DEBUG_BUILD_DERIVED_DATA_PATH = "#{DEBUG_EXPORT_BASE}/archive/DerivedData"
RELEASE_BUILD_DERIVED_DATA_PATH = "#{RELEASE_EXPORT_BASE}/archive/DerivedData"

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