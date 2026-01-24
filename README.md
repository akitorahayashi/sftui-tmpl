## Overview

This is an iOS app template based on SwiftUI with MVVM architecture.

## Customization Steps

When starting a new project from this template, follow these steps to set project-specific values.

### 1. Configure Environment Variables

Copy `.env.example` to `.env` and update the values as needed.

#### Simulator Configuration

This project uses separate simulators for development and testing to enable parallel workflows:

- `DEV_SIMULATOR_UDID`: UDID of the simulator used for app execution, debugging, and UI verification (used by `just boot`, `just run-debug`, etc.)
- `TEST_SIMULATOR_UDID`: UDID of the simulator used for automated test execution (used by `just test`, `just unit-test`, etc.)

To find your simulator UDID, run `xcrun simctl list devices` and copy the UUID of the desired simulator.

**Note:** Both variables must be set for full functionality. If you use the same simulator for both, set the same UDID for both variables.

Next, update the values in various configuration files to match your new project name.

#### project.yml

This is the source file for the Xcode project (`.xcodeproj`).

| Setting Item | Current Value | Change Example (`NewApp`) | Details |
|---|---|---|---|
| `name` | `TemplateApp` | `NewApp` | Project name. Match it with the directory name. |
| `bundleIdPrefix` | `com.akitorahayashi` | `com.yourcompany` | Change to your bundle ID prefix. |
| `targets.TemplateApp.sources` | `[App]` | `[App]` | The source directory for the main app. This path is generic and typically does not require changes. |
| `targets.TemplateAppTests.sources` | `[Tests/Unit]` | `[Tests/Unit]` | The source directory for unit tests. This path is generic and typically does not require changes. |
| `targets.TemplateAppIntgTests.sources` | `[Tests/Intg]` | `[Tests/Intg]` | The source directory for integration tests. This path is generic and typically does not require changes. |
| `targets.TemplateAppUITests.sources` | `[Tests/UI]` | `[Tests/UI]` | The source directory for UI tests. This path is generic and typically does not require changes. |
| `schemes` | `TemplateApp`, `TemplateAppTests` ... | `NewApp`, `NewAppTests` ... | Change scheme names to match the new project name. |

**Note:** After changing `project.yml`, be sure to run `just gen-pj` to regenerate the `.xcodeproj` file.

#### Info.plist Files

In the `Info.plist` files for each target, the bundle ID (`CFBundleIdentifier`) must match the value set in `project.yml`.

| File | Key to Update | Example Changed Value (`NewApp`) |
|---|---|---|
| `App/Info.plist` | `CFBundleIdentifier` | `com.yourcompany.NewApp` |
| `Tests/Unit/Info.plist` | `CFBundleIdentifier` | `com.yourcompany.NewAppTests` |
| `Tests/Intg/Info.plist` | `CFBundleIdentifier` | `com.yourcompany.NewAppIntgTests` |
| `Tests/UI/Info.plist` | `CFBundleIdentifier` | `com.yourcompany.NewAppUITests` |

#### justfile

This file defines development commands.

| Variable Name | Current Value | Change Example (`NewApp`) | Details |
|---|---|---|---|
| `PROJECT_FILE` | `"TemplateApp.xcodeproj"` | `"NewApp.xcodeproj"` | Update to the `name` from `project.yml` with `.xcodeproj` appended. |
| `APP_BUNDLE_ID` | `"com.akitorahayashi.TemplateApp"` | `"com.yourcompany.NewApp"` | Update to the combination of `bundleIdPrefix` and `name` from `project.yml`. |
| `DEBUG_APP_PATH` | `".../Products/Debug-iphonesimulator/TemplateApp.app"` | `".../Products/Debug-iphonesimulator/NewApp.app"` | Update the app name in the path. |
| `RELEASE_APP_PATH` | `".../Products/Release-iphonesimulator/TemplateApp.app"` | `".../Products/Release-iphonesimulator/NewApp.app"` | Update the app name in the path. |

#### fastlane/config.rb

This is the configuration file for `fastlane`. It defines specific behaviors for building and testing.

| Constant Name | Current Value | Change Example (`NewApp`) | Details |
|---|---|---|---|
| `PROJECT_PATH` | `"TemplateApp.xcodeproj"` | `"NewApp.xcodeproj"` | Update the project file name. |
| `SCHEMES[:app]` | `"TemplateApp"` | `"NewApp"` | Update the scheme name for the main app. |
| `SCHEMES[:unit_test]` | `"TemplateAppTests"` | `"NewAppTests"` | Update the scheme name for unit tests. |
| `SCHEMES[:ui_test]` | `"TemplateAppUITests"` | `"NewAppUITests"` | Update the scheme name for UI tests. |
| `DEBUG_ARCHIVE_PATH` | `.../archive/TemplateApp.xcarchive` | `.../archive/NewApp.xcarchive` | Update the app name in the archive path. |
| `RELEASE_ARCHIVE_PATH` | `.../archive/TemplateApp.xcarchive` | `.../archive/NewApp.xcarchive` | Update the app name in the archive path. |

#### .swiftlint.yml

This is the configuration file for SwiftLint. The `included` paths (`App`, `Tests`) use generic directory names and typically do not require changes.

### 2. GitHub Actions Configuration

| Setting Item | Current Value | Details |
|---|---|---|
| `name` | `Template App CI/CD Pipeline` | Display name for the GitHub Actions workflow. Change to match the project name. |
## Just Contract

This project exposes a standardized set of recipes through `just`. These commands are stable and used by CI automation:

### Setup and Project Generation
- `just setup` - Initialize project: install dependencies (Ruby, Mint) and generate Xcode project
- `just gen-pj` - Generate Xcode project from `project.envsubst.yml`

### Code Quality
- `just check` - Verify code formatting and linting
- `just fix` - Apply code formatting and linting fixes

### Testing
- `just build-test` - Build for testing (CI-compatible)
- `just unit-test-without-building` - Run unit tests without building
- `just intg-test-without-building` - Run integration tests without building
- `just ui-test-without-building` - Run UI tests without building

### Additional Commands
- `just test` - Run all tests (with build)
- `just unit-test` - Run unit tests (with build)
- `just intg-test` - Run integration tests (with build)
- `just ui-test` - Run UI tests (with build)
- `just run-debug` - Build debug, install and launch on local simulator
- `just run-release` - Build release, install and launch on local simulator
- `just boot` - Boot the development simulator
- `just boot-test` - Boot the test simulator
