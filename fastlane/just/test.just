import 'module.just'

# ==============================================================================
# Testing (Fastlane)
# ==============================================================================

# Run all tests (unit, integration, UI)
test:
    @just build-test
    @just unit-test-without-building
    @just intg-test-without-building
    @just ui-test-without-building

# Run unit tests
unit-test:
    @just _run_fastlane "unit_test"

# Run unit tests without building
unit-test-without-building:
    @just _run_fastlane "unit_test_without_building"

# Run integration tests
intg-test:
    @just _run_fastlane "intg_test"

# Run integration tests without building
intg-test-without-building:
    @just _run_fastlane "intg_test_without_building"

# Run UI tests
ui-test:
    @just _run_fastlane "ui_test"

# Run UI tests without building
ui-test-without-building:
    @just _run_fastlane "ui_test_without_building"
