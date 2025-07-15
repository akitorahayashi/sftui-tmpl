## 概要

SwiftUI ベースの iOS アプリテンプレートです

## カスタマイズの手順

このテンプレートを新しいプロジェクトで使用する際は、まず最初にルート直下にある `TemplateApp` ディレクトリの名前を、あなたのプロジェクト名に変更してください（例: `MyApp`）。そして、`TemplateApp/TemplateApp.swift` のファイル名も、プロジェクト名に合わせて変更してください（例: `MyApp/MyApp.swift`）。同様に `TemplateAppTests` や `TemplateAppUITests` ディレクトリも、新しいテストターゲット名に合わせて変更することをおすすめします（例: `MyAppTests`, `MyAppUITests`）。これらの変更は、後述する多くの設定ファイル中のパスの記述に影響します。

また、このテンプレートはサンプルとしての設定値が含まれています。新しいプロジェクトに合わせて、必要に応じて以下の項目を調整してください。

### project.yml

| 設定項目 | 現在値 | 詳細 |
|---|---|---|
| `name` | `TemplateApp` | プロジェクト名に変更 |
| `bundleIdPrefix` | `com.example` | プロジェクトのバンドルIDプレフィックスに変更 |
| `MARKETING_VERSION` | `1.0.0` | アプリのマーケティングバージョン |
| `CURRENT_PROJECT_VERSION` | `1` | アプリのビルド番号 |
| `IPHONEOS_DEPLOYMENT_TARGET` | `15.0` | iOSのデプロイメントターゲット |
| `SWIFT_VERSION` | `5.9` | 使用するSwiftのバージョン |
| `targets.TemplateApp.settings.PRODUCT_NAME` | `$(TARGET_NAME)` | プロダクト名。通常はターゲット名と同じ |
| `targets.TemplateApp.settings.PRODUCT_DISPLAY_NAME` | `$(TARGET_NAME)` | アプリの表示名。通常はターゲット名と同じ |
| `targets.TemplateApp.sources` | `[TemplateApp]` | アプリ本体のソースディレクトリ。ディレクトリ名変更に合わせて修正 |
| `targets.TemplateApp.settings.INFOPLIST_FILE` | `TemplateApp/Info.plist` | アプリ本体のInfo.plistパス。ディレクトリ名変更に合わせて修正 |
| `targets.TemplateAppTests.settings.PRODUCT_NAME` | `$(TARGET_NAME)` | プロダクト名。通常はターゲット名と同じ |
| `targets.TemplateAppTests.settings.PRODUCT_DISPLAY_NAME` | `$(TARGET_NAME)` | アプリの表示名。通常はターゲット名と同じ |
| `targets.TemplateAppTests.sources` | `[TemplateAppTests]` | Unitテストのソースディレクトリ。ディレクトリ名変更に合わせて修正 |
| `targets.TemplateAppTests.settings.INFOPLIST_FILE` | `TemplateAppTests/Info.plist` | UnitテストのInfo.plistパス。ディレクトリ名変更に合わせて修正 |
| `targets.TemplateAppUITests.settings.PRODUCT_NAME` | `$(TARGET_NAME)` | プロダクト名。通常はターゲット名と同じ |
| `targets.TemplateAppUITests.settings.PRODUCT_DISPLAY_NAME` | `$(TARGET_NAME)` | アプリの表示名。通常はターゲット名と同じ |
| `targets.TemplateAppUITests.sources` | `[TemplateAppUITests]` | UIテストのソースディレクトリ。ディレクトリ名変更に合わせて修正 |
| `targets.TemplateAppUITests.settings.INFOPLIST_FILE` | `TemplateAppUITests/Info.plist` | UIテストのInfo.plistパス。ディレクトリ名変更に合わせて修正 |
| `schemes.TemplateApp.build.targets.TemplateApp` | `all` | アプリ本体のスキーム設定。プロジェクト名に合わせてスキーム名やターゲット名を修正 |
| `schemes.TemplateAppTests.build.targets.TemplateAppTests` | `all` | Unitテストのスキーム設定。プロジェクト名に合わせてスキーム名やターゲット名を修正 |
| `schemes.TemplateAppUITests.build.targets.TemplateAppUITests` | `all` | UIテストのスキーム設定。プロジェクト名に合わせてスキーム名やターゲット名を修正 |

**注意:**
- ディレクトリ名変更後、`sources` や `INFOPLIST_FILE` のパスが正しく更新されていることを確認してください。

### 各 Info.plist の設定

`project.yml` の設定に基づき、ほとんどの値はXcodeGenによって自動的に設定されますが、`CFBundleIdentifier`（バンドルID）のみ手動で設定する必要があります。これは、`Makefile` 内の一部のスクリプトが `Info.plist` から直接バンドルIDを読み取る必要があるためです。

プロジェクトをカスタマイズする際は、以下のファイルの `CFBundleIdentifier` を、あなたのプロジェクトのバンドルIDに合わせて手動で修正してください。

- `TemplateApp/Info.plist`
- `TemplateAppTests/Info.plist`
- `TemplateAppUITests/Info.plist`

### Makefile

| 設定項目 | 現在値 | 詳細 |
|---|---|---|
| `PROJECT_FILE` | `TemplateApp.xcodeproj` | プロジェクトファイル名。通常 `project.yml` の `name` と連動してXcodeGenが生成 |
| `APP_SCHEME` | `TemplateApp` | アプリ本体のスキーム名。`project.yml` の `name` と連動させることを推奨 |
| `UNIT_TEST_SCHEME` | `TemplateAppTests` | Unitテストのスキーム名。同様にプロジェクト名に合わせて変更 |
| `UI_TEST_SCHEME` | `TemplateAppUITests` | UIテストのスキーム名。同様にプロジェクト名に合わせて変更 |
| `ARCHIVE_PATH` | `$(OUTPUT_DIR)/archives/TemplateApp.xcarchive` | アーカイブ出力パス。`APP_SCHEME` と連動して変更 |
| `LOCAL_SIMULATOR_NAME` | `iPhone 16 Pro` | ローカル実行時のシミュレータ名 |
| `LOCAL_SIMULATOR_OS` | `26.0` | ローカル実行時のシミュレータOSバージョン |
| `LOCAL_SIMULATOR_UDID` | `5495CFE4-9EBC-45C5-8F85-37E0E143B3CC` | ローカル実行時のシミュレータUDID |
| `APP_BUNDLE_ID` | `com.example.TemplateApp` | アプリのバンドルID。`project.yml` と一致させる |

**注意:**
- `find-test-artifacts` ターゲット内の `TemplateApp.app` という記述も、新しいアプリ名 (`$(APP_SCHEME).app`) に合わせて確認・修正が必要な場合があります。

### .swiftlint.yml

| 設定項目 | 現在値 | 詳細 |
|---|---|---|
| `included` | `TemplateApp/**/*.swift` | リンティング対象ディレクトリ。プロジェクトのメインソースディレクトリ名に変更 |
| | `TemplateAppTests/**/*.swift` | リンティング対象ディレクトリ。Unitテストのソースディレクトリ名に変更 |
| | `TemplateAppUITests/**/*.swift` | リンティング対象ディレクトリ。UIテストのソースディレクトリ名に変更 |

**注意:**
- ディレクトリ名を変更した場合、上記の `included` のパスを新しいディレクトリ構成に合わせて修正してください。
- `excluded` セクションもプロジェクトの構成によって調整が必要な場合があります。

### .swiftformat

| 設定項目 | 現在値 | 詳細 |
|---|---|---|
| `--swiftversion` | `5.9` | 使用するSwiftのバージョン。`project.yml` の `SWIFT_VERSION` と一致させることを推奨 |

**注意:**
- `--exclude` で指定されている除外パスも、プロジェクトのディレクトリ構造に合わせて確認・調整してください。

### .github/workflows/ci-cd-pipeline.yml

| 設定項目 | 現在値 | 詳細 |
|---|---|---|
| `name` | `Template App CI/CD Pipeline` | GitHub Actions ワークフローの表示名。プロジェクト名に合わせて変更 |
