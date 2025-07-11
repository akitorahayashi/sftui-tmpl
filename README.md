## 概要

SwiftUI ベースの iOS アプリテンプレートです

## カスタマイズの手順

このテンプレートを新しいプロジェクトで使用する際は、まず最初にルート直下にある `TemplateApp` ディレクトリの名前を、あなたのプロジェクト名に変更してください（例: `MyApp`）。同様に `TemplateAppTests` や `TemplateAppUITests` ディレクトリも、新しいテストターゲット名に合わせて変更することをおすすめします（例: `MyAppTests`, `MyAppUITests`）。これらの変更は、後述する多くの設定ファイル中のパスの記述に影響します。

また、このテンプレートはサンプルとしての設定値が含まれています。新しいプロジェクトに合わせて、必要に応じて以下の項目を調整してください。

### project.yml

| 設定項目 | 現在値 | 詳細 |
|---|---|---|
| `name` | `TemplateApp` | プロジェクト名に変更 |
| `bundleIdPrefix` | `com.example` | プロジェクトのバンドルIDプレフィックスに変更 |
| `MARKETING_VERSION` | `1.0.0` | アプリのマーケティングバージョン |
| `CURRENT_PROJECT_VERSION` | `1` | アプリのビルド番号 |
| `IPHONEOS_DEPLOYMENT_TARGET` | `15.0` | iOSのデプロイメントターゲット |
| `SWIFT_VERSION` | `5.0` | 使用するSwiftのバージョン |
| `targets.TemplateApp.settings.PRODUCT_BUNDLE_IDENTIFIER` | `com.example.templateapp` | アプリ本体のバンドルID |
| `targets.TemplateApp.sources` | `[TemplateApp]` | アプリ本体のソースディレクトリ。ディレクトリ名変更に合わせて修正 |
| `targets.TemplateApp.settings.INFOPLIST_FILE` | `TemplateApp/Info.plist` | アプリ本体のInfo.plistパス。ディレクトリ名変更に合わせて修正 |
| `targets.TemplateAppTests.settings.PRODUCT_BUNDLE_IDENTIFIER` | `com.example.templateapp.tests` | UnitテストターゲットのバンドルID |
| `targets.TemplateAppTests.sources` | `[TemplateAppTests]` | Unitテストのソースディレクトリ。ディレクトリ名変更に合わせて修正 |
| `targets.TemplateAppTests.settings.INFOPLIST_FILE` | `TemplateAppTests/Info.plist` | UnitテストのInfo.plistパス。ディレクトリ名変更に合わせて修正 |
| `targets.TemplateAppUITests.settings.PRODUCT_BUNDLE_IDENTIFIER` | `com.example.templateapp.uitests` | UIテストターゲットのバンドルID |
| `targets.TemplateAppUITests.sources` | `[TemplateAppUITests]` | UIテストのソースディレクトリ。ディレクトリ名変更に合わせて修正 |
| `targets.TemplateAppUITests.settings.INFOPLIST_FILE` | `TemplateAppUITests/Info.plist` | UIテストのInfo.plistパス。ディレクトリ名変更に合わせて修正 |
| `schemes.TemplateApp.build.targets.TemplateApp` | `all` | アプリ本体のスキーム設定。プロジェクト名に合わせてスキーム名やターゲット名を修正 |
| `schemes.TemplateAppTests.build.targets.TemplateAppTests` | `all` | Unitテストのスキーム設定。プロジェクト名に合わせてスキーム名やターゲット名を修正 |
| `schemes.TemplateAppUITests.build.targets.TemplateAppUITests` | `all` | UIテストのスキーム設定。プロジェクト名に合わせてスキーム名やターゲット名を修正 |

**注意:**
- 上記以外にも、プロジェクトの要件に応じて他のパラメータ (例: `configs`, `options` など) の調整が必要な場合があります。
- ディレクトリ名変更後、`sources` や `INFOPLIST_FILE` のパスが正しく更新されていることを確認してください。

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
| `APP_BUNDLE_ID` | `com.example.templateapp` | アプリのバンドルID。`project.yml` と一致させる |

**注意:**
- `find-test-artifacts` ターゲット内の `TemplateApp.app` という記述も、新しいアプリ名 (`$(APP_SCHEME).app`) に合わせて確認・修正が必要な場合があります。
- シミュレータ関連の設定 (`LOCAL_SIMULATOR_...`) は、開発環境に合わせて適宜変更してください。

### 各 Info.plist

これらのファイルの値は基本的に `project.yml` の設定に基づいてXcodeGenによって自動生成・更新されます。手動での直接編集は通常不要ですが、参考情報として主要項目を記載します。ディレクトリ名変更後のパスに合わせて確認してください。

**`TemplateApp/Info.plist`** (アプリ本体のInfo.plist)

| 設定項目 | 現在値 | 詳細 |
|---|---|---|
| `CFBundleIdentifier` | `com.example.templateapp` | project.ymlの `targets.TemplateApp.settings.PRODUCT_BUNDLE_IDENTIFIER` と連動 |
| `CFBundleName` | `TemplateApp` | project.ymlの `name` やターゲット名と連動 |
| `CFBundleDisplayName` | `TemplateApp` | project.ymlの `name` やターゲット名と連動 |
| `CFBundleShortVersionString` | `1.0.0` | project.ymlの `MARKETING_VERSION` と連動 |
| `CFBundleVersion` | `1` | project.ymlの `CURRENT_PROJECT_VERSION` と連動 |

**`TemplateAppTests/Info.plist`** (UnitテストのInfo.plist)

| 設定項目 | 現在値 | 詳細 |
|---|---|---|
| `CFBundleIdentifier` | `com.example.templateapp.tests` | project.ymlの `targets.TemplateAppTests.settings.PRODUCT_BUNDLE_IDENTIFIER` と連動 |
| `CFBundleName` | `TemplateAppTests` | project.ymlのターゲット名と連動 |
| `CFBundleDisplayName` | `TemplateAppTests` | project.ymlのターゲット名と連動 |
| `CFBundleShortVersionString` | `1.0.0` | project.ymlの `MARKETING_VERSION` と連動 |
| `CFBundleVersion` | `1` | project.ymlの `CURRENT_PROJECT_VERSION` と連動 |

**`TemplateAppUITests/Info.plist`** (UIテストのInfo.plist)

| 設定項目 | 現在値 | 詳細 |
|---|---|---|
| `CFBundleIdentifier` | `com.example.templateapp.uitests` | project.ymlの `targets.TemplateAppUITests.settings.PRODUCT_BUNDLE_IDENTIFIER` と連動 |
| `CFBundleName` | `TemplateAppUITests` | project.ymlのターゲット名と連動 |
| `CFBundleDisplayName` | `TemplateAppUITests` | project.ymlのターゲット名と連動 |
| `CFBundleShortVersionString` | `1.0.0` | project.ymlの `MARKETING_VERSION` と連動 |
| `CFBundleVersion` | `1` | project.ymlの `CURRENT_PROJECT_VERSION` と連動 |

**注意:**
- `project.yml` を変更した後は、`mint run xcodegen generate` コマンドを実行してプロジェクトファイルとこれらのInfo.plistを更新してください。

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
