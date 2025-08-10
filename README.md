## 概要

SwiftUI ベースの iOS アプリテンプレートです

## カスタマイズの手順

このテンプレートから新しいプロジェクトを開始する際は、以下の手順に従ってプロジェクト固有の値を設定してください。

### 1. プロジェクト名とディレクトリの変更

まず、プロジェクトのルートディレクトリで、テンプレートのプレースホルダー名をあなたの新しいプロジェクト名に変更します。例えば、新しいプロジェクト名が `NewApp` の場合、以下のように変更します。

1.  `TemplateApp` -> `NewApp`
2.  `TemplateAppTests` -> `NewAppTests`
3.  `TemplateAppUITests` -> `NewAppUITests`

### 2. 設定ファイルの更新

次に、各種設定ファイル内の値を、新しいプロジェクト名に合わせて更新します。

#### project.yml

Xcodeプロジェクト (`.xcodeproj`) の元となるファイルです。

| 設定項目 | 現在の値 | 変更例 (`NewApp`) | 詳細 |
|---|---|---|---|
| `name` | `TemplateApp` | `NewApp` | プロジェクト名。ディレクトリ名と一致させます。 |
| `bundleIdPrefix` | `com.akitorahayashi` | `com.yourcompany` | あなたのバンドルIDプレフィックスに変更します。 |
| `targets.TemplateApp.sources` | `[TemplateApp]` | `[NewApp]` | アプリ本体のソースディレクトリ名を指定します。 |
| `targets.TemplateAppTests.sources` | `[TemplateAppTests]` | `[NewAppTests]` | Unitテストのソースディレクトリ名を指定します。 |
| `targets.TemplateAppUITests.sources` | `[TemplateAppUITests]` | `[NewAppUITests]` | UIテストのソースディレクトリ名を指定します。 |
| `schemes` | `TemplateApp`, `TemplateAppTests` ... | `NewApp`, `NewAppTests` ... | スキーム名を新しいプロジェクト名に合わせて変更します。 |

**注意:** `project.yml` を変更した後は、必ず `make gen-proj` を実行して `.xcodeproj` ファイルを再生成してください。

#### Info.plist ファイル

各ターゲットの`Info.plist`ファイル内に含まれるバンドルID (`CFBundleIdentifier`) を、`project.yml`で設定した値と一致させる必要があります。

| ファイル | 更新が必要なキー | 変更後の値の例 (`NewApp`) |
|---|---|---|
| `TemplateApp/Info.plist` | `CFBundleIdentifier` | `com.yourcompany.NewApp` |
| `TemplateAppTests/Info.plist` | `CFBundleIdentifier` | `com.yourcompany.NewAppTests` |
| `TemplateAppUITests/Info.plist` | `CFBundleIdentifier` | `com.yourcompany.NewAppUITests` |

#### Makefile

開発用のコマンドを定義したファイルです。

| 変数名 | 現在の値 | 変更例 (`NewApp`) | 詳細 |
|---|---|---|---|
| `PROJECT_FILE` | `TemplateApp.xcodeproj` | `NewApp.xcodeproj` | `project.yml` の `name` に `.xcodeproj` を付けた値に更新します。 |
| `APP_BUNDLE_ID` | `com.akitorahayashi.TemplateApp` | `com.yourcompany.NewApp` | `project.yml` の `bundleIdPrefix` と `name` を組み合わせた値に更新します。 |
| `DEBUG_APP_PATH` | `.../Products/Debug-iphonesimulator/TemplateApp.app` | `.../Products/Debug-iphonesimulator/NewApp.app` | パスに含まれるアプリ名を更新します。 |
| `RELEASE_APP_PATH` | `.../Products/Release-iphonesimulator/TemplateApp.app` | `.../Products/Release-iphonesimulator/NewApp.app` | パスに含まれるアプリ名を更新します。 |

#### fastlane/config.rb

`fastlane` の設定ファイルです。ビルドやテストの具体的な挙動を定義します。

| 定数名 | 現在の値 | 変更例 (`NewApp`) | 詳細 |
|---|---|---|---|
| `PROJECT_PATH` | `"TemplateApp.xcodeproj"` | `"NewApp.xcodeproj"` | プロジェクトファイル名を更新します。 |
| `SCHEMES[:app]` | `"TemplateApp"` | `"NewApp"` | アプリ本体のスキーム名を更新します。 |
| `SCHEMES[:unit_test]` | `"TemplateAppTests"` | `"NewAppTests"` | Unitテストのスキーム名を更新します。 |
| `SCHEMES[:ui_test]` | `"TemplateAppUITests"` | `"NewAppUITests"` | UIテストのスキーム名を更新します。 |
| `DEBUG_ARCHIVE_PATH` | `.../archive/TemplateApp.xcarchive` | `.../archive/NewApp.xcarchive` | アーカイブパスに含まれるアプリ名を更新します。 |
| `RELEASE_ARCHIVE_PATH` | `.../archive/TemplateApp.xcarchive` | `.../archive/NewApp.xcarchive` | アーカイブパスに含まれるアプリ名を更新します。 |

#### .swiftlint.yml

SwiftLintの設定ファイルです。

| 設定項目 | 現在の値 | 変更例 (`NewApp`) | 詳細 |
|---|---|---|---|
| `included` | `- TemplateApp` | `- NewApp` | リンティング対象のディレクトリ名を更新します。 |
| | `- TemplateAppTests` | `- NewAppTests` | |
| | `- TemplateAppUITests` | `- NewAppUITests` | |


### .github/workflows/ci-cd-pipeline.yml

| 設定項目 | 現在値 | 詳細 |
|---|---|---|
| `name` | `Template App CI/CD Pipeline` | GitHub Actions ワークフローの表示名。プロジェクト名に合わせて変更 |
