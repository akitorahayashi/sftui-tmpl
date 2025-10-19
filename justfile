# ==============================================================================
# justfile for TemplateApp automation
# ==============================================================================

set dotenv-load

# --- PROJECT SETTINGS ---
PROJECT_FILE := "TemplateApp.xcodeproj"
APP_BUNDLE_ID := "com.akitorahayashi.TemplateApp"

# --- PROJECT SPECIFIC PATHS ---
TEST_DERIVED_DATA_PATH := "fastlane/build/test-results/DerivedData"
DEBUG_APP_PATH := TEST_DERIVED_DATA_PATH + "/Debug/Build/Products/Debug-iphonesimulator/TemplateApp.app"
RELEASE_APP_PATH := TEST_DERIVED_DATA_PATH + "/Release/Build/Products/Release-iphonesimulator/TemplateApp.app"
HOME_DIR := env("HOME")
SWIFTPM_CACHE_PATH := env("SWIFTPM_CACHE_PATH", HOME_DIR + "/Library/Caches/org.swift.swiftpm")

# --- ENVIRONMENT VARIABLES ---
TEAM_ID := env("TEAM_ID", "")
LOCAL_SIMULATOR_UDID := env("LOCAL_SIMULATOR_UDID", "")

# default recipe
default: help

# Show available recipes
help:
    @echo "Usage: just [recipe]"
    @echo "Available recipes:"
    @just --list | tail -n +2 | awk '{printf "  \033[36m%-30s\033[0m %s\n", $1, substr($0, index($0, $2))}'

# ==============================================================================
# Environment Setup
# ==============================================================================

# Initialize project: install dependencies and generate project files
setup:
    @echo "Installing Ruby gems..."
    @bundle install
    @echo "Bootstrapping Mint packages..."
    @mint bootstrap
    @echo "Generating Xcode project..."
    @just gen-proj

# Generate Xcode project
gen-proj:
    @echo "Generating Xcode project with TEAM_ID: {{TEAM_ID}}"
    @TEAM_ID={{TEAM_ID}} envsubst < project.envsubst.yml > project.yml
    @mint run xcodegen generate

# Reset SwiftPM cache, dependencies, and build artifacts
resolve-pkg:
    @echo "Removing SwiftPM build and cache..."
    @rm -rf .build
    @rm -rf {{SWIFTPM_CACHE_PATH}}
    @echo "✅ SwiftPM build and cache removed."
    @echo "Resolving Swift package dependencies..."
    @xcodebuild -resolvePackageDependencies -project {{PROJECT_FILE}}
    @echo "✅ Package dependencies resolved."

# Open project in Xcode
open:
    @xed {{PROJECT_FILE}}

# ==============================================================================
# Local Simulator
# ==============================================================================

# Boot local simulator
boot:
    @if [ -z "{{LOCAL_SIMULATOR_UDID}}" ]; then \
        echo "LOCAL_SIMULATOR_UDID is not set. Please set it in your .env"; \
        exit 1; \
    fi
    @echo "Booting local simulator: UDID: {{LOCAL_SIMULATOR_UDID}}"
    @if xcrun simctl list devices | grep -q "{{LOCAL_SIMULATOR_UDID}} (Booted)"; then \
        echo "⚡️ Simulator is already booted."; \
    else \
        xcrun simctl boot {{LOCAL_SIMULATOR_UDID}}; \
        echo "✅ Simulator booted."; \
    fi
    @open -a Simulator

# Build debug, install, and launch on local simulator
run-debug:
    @just boot
    @bundle exec fastlane build_for_testing
    @xcrun simctl install {{LOCAL_SIMULATOR_UDID}} {{DEBUG_APP_PATH}}
    @xcrun simctl launch {{LOCAL_SIMULATOR_UDID}} {{APP_BUNDLE_ID}}

# Build release, install, and launch on local simulator
run-release:
    @just boot
    @bundle exec fastlane build_for_testing configuration:Release
    @xcrun simctl install {{LOCAL_SIMULATOR_UDID}} {{RELEASE_APP_PATH}}
    @xcrun simctl launch {{LOCAL_SIMULATOR_UDID}} {{APP_BUNDLE_ID}}

# ==============================================================================
# Build & Sign
# ==============================================================================

# Build Debug archive (unsigned)
build-debug:
    @bundle exec fastlane build_debug

# Build Release archive (unsigned)
build-release:
    @bundle exec fastlane build_release

# Sign debug archive for development
sign-debug-development:
    @bundle exec fastlane sign_debug_development

# Sign release archive for development
sign-release-development:
    @bundle exec fastlane sign_release export_method:development

# Sign release archive for App Store
sign-release-app-store:
    @bundle exec fastlane sign_release export_method:app_store

# Sign release archive for Ad Hoc
sign-release-ad-hoc:
    @bundle exec fastlane sign_release export_method:ad_hoc

# Sign release archive for Enterprise
sign-release-enterprise:
    @bundle exec fastlane sign_release export_method:enterprise

# ==============================================================================
# Testing
# ==============================================================================

# Build for testing
build-for-testing:
    @bundle exec fastlane build_for_testing

# Run unit tests
unit-test:
    @bundle exec fastlane unit_test

# Run unit tests without building
unit-test-without-building:
    @bundle exec fastlane unit_test_without_building

# Run UI tests
ui-test:
    @bundle exec fastlane ui_test

# Run UI tests without building
ui-test-without-building:
    @bundle exec fastlane ui_test_without_building

# Run all tests (unit, UI, package)
test-all:
    @bundle exec fastlane test_all

# ==============================================================================
# Lint & Format
# ==============================================================================

# Format code
format:
    @mint run swiftformat .
    @mint run swiftlint lint --fix .

# Check code format
lint:
    @mint run swiftformat --lint .
    @mint run swiftlint lint --strict
