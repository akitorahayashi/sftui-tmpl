# ==============================================================================
# Build & Run (Fastlane)
# ==============================================================================

# Build Debug archive (unsigned)
build-debug:
    @bundle exec fastlane build_debug

# Build Release archive (unsigned)
build-release:
    @bundle exec fastlane build_release

# Build debug, install, and launch on local simulator
run-debug:
    @just boot
    @bundle exec fastlane build_for_testing udid:{{DEV_SIMULATOR_UDID}}
    @xcrun simctl install {{DEV_SIMULATOR_UDID}} {{DEBUG_APP_PATH}}
    @xcrun simctl launch {{DEV_SIMULATOR_UDID}} {{APP_BUNDLE_ID}}

# Build release, install, and launch on local simulator
run-release:
    @just boot
    @bundle exec fastlane build_for_testing configuration:Release udid:{{DEV_SIMULATOR_UDID}}
    @xcrun simctl install {{DEV_SIMULATOR_UDID}} {{RELEASE_APP_PATH}}
    @xcrun simctl launch {{DEV_SIMULATOR_UDID}} {{APP_BUNDLE_ID}}

# Build for testing
build-test:
    @just _run_fastlane "build_for_testing"
