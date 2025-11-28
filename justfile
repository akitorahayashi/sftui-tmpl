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
DEV_SIMULATOR_UDID := env("DEV_SIMULATOR_UDID", "")
TEST_SIMULATOR_UDID := env("TEST_SIMULATOR_UDID", "")

# ==============================================================================
# Imports (Fastlane Domain Split)
# ==============================================================================
import 'fastlane/test.just'
import 'fastlane/build.just'
import 'fastlane/sign.just'

# ==============================================================================
# Main
# ==============================================================================

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
    @if [ ! -f .env ]; then \
        cp .env.example .env && \
        echo "📝 Created .env file from .env.example."; \
    else \
        echo "📝 .env file already exists."; \
    fi
    @echo "Bootstrapping Mint packages..."
    @mint bootstrap
    @echo "Generating Xcode project..."
    @just gen-pj

# Generate Xcode project
gen-pj:
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
    @if [ -z "{{DEV_SIMULATOR_UDID}}" ]; then \
        echo "DEV_SIMULATOR_UDID is not set. Please set it in your .env"; \
        exit 1; \
    fi
    @echo "Booting development simulator: UDID: {{DEV_SIMULATOR_UDID}}"
    @if xcrun simctl list devices | grep -q "{{DEV_SIMULATOR_UDID}} (Booted)"; then \
        echo "⚡️ Simulator is already booted."; \
    else \
        xcrun simctl boot {{DEV_SIMULATOR_UDID}}; \
        echo "✅ Simulator booted."; \
    fi
    @open -a Simulator

# Boot test simulator
boot-test:
    @if [ -z "{{TEST_SIMULATOR_UDID}}" ]; then \
        echo "TEST_SIMULATOR_UDID is not set. Please set it in your .env"; \
        exit 1; \
    fi
    @echo "Booting test simulator: UDID: {{TEST_SIMULATOR_UDID}}"
    @if xcrun simctl list devices | grep -q "{{TEST_SIMULATOR_UDID}} (Booted)"; then \
        echo "⚡️ Simulator is already booted."; \
    else \
        xcrun simctl boot {{TEST_SIMULATOR_UDID}}; \
        echo "✅ Simulator booted."; \
    fi
    @open -a Simulator

# List available simulators
siml:
    @xcrun simctl list devices available

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

# ==============================================================================
# CLEANUP
# ==============================================================================

# Clean build artifacts, caches, and generated files
clean:
    @rm -rf {{PROJECT_FILE}}
    @rm -rf fastlane/build
    @rm -rf fastlane/logs
    @rm -rf fastlane/report.xml
    @rm -rf .build
    @rm -rf {{SWIFTPM_CACHE_PATH}}
