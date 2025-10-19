## Overview

This is an iOS app template based on SwiftUI.

## Customization Steps

When starting a new project from this template, follow these steps to set project-specific values.

### 1. Change Project Name and Directory

First, in the project root directory, change the template placeholder names to your new project name. For example, if your new project name is `NewApp`, change as follows:

1. `TemplateApp` -> `NewApp`
2. `TemplateAppTests` -> `NewAppTests`
3. `TemplateAppUITests` -> `NewAppUITests`

### 2. Update Configuration Files

Next, update the values in various configuration files to match your new project name.

#### project.yml

This is the source file for the Xcode project (`.xcodeproj`).

| Setting Item | Current Value | Change Example (`NewApp`) | Details |
|---|---|---|---|
| `name` | `TemplateApp` | `NewApp` | Project name. Match it with the directory name. |
| `bundleIdPrefix` | `com.akitorahayashi` | `com.yourcompany` | Change to your bundle ID prefix. |
| `targets.TemplateApp.sources` | `[TemplateApp]` | `[NewApp]` | Specify the source directory name for the main app. |
| `targets.TemplateAppTests.sources` | `[TemplateAppTests]` | `[NewAppTests]` | Specify the source directory name for unit tests. |
| `targets.TemplateAppUITests.sources` | `[TemplateAppUITests]` | `[NewAppUITests]` | Specify the source directory name for UI tests. |
| `schemes` | `TemplateApp`, `TemplateAppTests` ... | `NewApp`, `NewAppTests` ... | Change scheme names to match the new project name. |

**Note:** After changing `project.yml`, be sure to run `just gen-proj` to regenerate the `.xcodeproj` file.

#### Info.plist Files

In the `Info.plist` files for each target, the bundle ID (`CFBundleIdentifier`) must match the value set in `project.yml`.

| File | Key to Update | Example Changed Value (`NewApp`) |
|---|---|---|
| `TemplateApp/Info.plist` | `CFBundleIdentifier` | `com.yourcompany.NewApp` |
| `TemplateAppTests/Info.plist` | `CFBundleIdentifier` | `com.yourcompany.NewAppTests` |
| `TemplateAppUITests/Info.plist` | `CFBundleIdentifier` | `com.yourcompany.NewAppUITests` |

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

This is the configuration file for SwiftLint.

| Setting Item | Current Value | Change Example (`NewApp`) | Details |
|---|---|---|---|
| `included` | `- TemplateApp` | `- NewApp` | Update the directory name for linting. |
| | `- TemplateAppTests` | `- NewAppTests` | |
| | `- TemplateAppUITests` | `- NewAppUITests` | |

### .github/workflows/ci-cd-pipeline.yml

| Setting Item | Current Value | Details |
|---|---|---|
| `name` | `Template App CI/CD Pipeline` | Display name for the GitHub Actions workflow. Change to match the project name. |
