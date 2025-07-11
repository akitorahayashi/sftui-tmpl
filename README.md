# TemplateApp

SwiftUI ベースの iOS アプリ用テンプレートです

## カスタマイズの手順

> 本テンプレートの各種設定値はサンプルです。新しいプロジェクトに合わせて適切に変更・調整してください。

1. project.yml  
   - 設定例:
     - `name`: TemplateApp
     - `bundleIdPrefix`: com.example
     - `MARKETING_VERSION`: 1.0.0
     - `CURRENT_PROJECT_VERSION`: 1
     - `IPHONEOS_DEPLOYMENT_TARGET`: 15.0
     - `SWIFT_VERSION`: 5.0
     - `targets.TemplateApp.settings.PRODUCT_BUNDLE_IDENTIFIER`: com.example.templateapp
     - `targets.TemplateAppTests.settings.PRODUCT_BUNDLE_IDENTIFIER`: com.example.templateapp.tests
     - `targets.TemplateAppUITests.settings.PRODUCT_BUNDLE_IDENTIFIER`: com.example.templateapp.uitests
   - ※ 'TemplateApp' や 'com.example.templateapp' などテンプレート名・バンドルID、ディレクトリ名、project.yml内のパスは新しいプロジェクト名・構成に変更してください。
   - 他のパラメータも必要に応じて調整してください。

2. Makefile のカスタマイズ
   - 設定例:
     - `LOCAL_SIMULATOR_NAME` : 「iPhone 16 Pro」
     - `LOCAL_SIMULATOR_OS` : 「26.0」
     - `LOCAL_SIMULATOR_UDID` : 「5495CFE4-9EBC-45C5-8F85-37E0E143B3CC」
     - `APP_BUNDLE_ID` : 「com.example.templateapp」
     - `APP_SCHEME` : 「TemplateApp」
     - `UNIT_TEST_SCHEME` : 「TemplateAppTests」
     - `UI_TEST_SCHEME` : 「TemplateAppUITests」
   - 他のパスや設定値もプロジェクトに合わせて調整してください。

3. TemplateApp/Info.plist、TemplateAppTests/Info.plist、TemplateAppUITests/Info.plist の初期値も、プロジェクトに合わせて変更してください。
   - 各 Info.plist には、CFBundleIdentifier などのプレースホルダー値が設定されています。
   - 必要に応じて CFBundleIdentifier やバージョン情報などを調整してください。
   - 例: TemplateAppUITests/Info.plist の CFBundleIdentifier は「com.example.templateapp.uitests」などになっています。
   - それぞれの Info.plist の初期値はテンプレート用です。

4. .swiftlint.yml 
   - included/excluded のパスや 'TemplateApp' などテンプレートの名前を変更

5. .swiftformat の Swiftバージョンを指定（--swiftversion）
   - 例: --swiftversion 5.9 など

6. .github/workflows/ci-cd-pipeline.yml のタイトルも、他アプリにテンプレートとして移す際はプロジェクト名等に合わせて変更してください。
   - `name:` の値がワークフローのタイトルです。現在は「CI/CD Pipeline」などになっています。
   - プロジェクト名や用途に合わせて調整してください。
