## 概要

SwiftUI ベースの iOS アプリテンプレートです

## カスタマイズの手順

このテンプレートはサンプル設定値が含まれています。新しいプロジェクトに合わせて、以下の項目を調整してください。

1. project.yml
    - 主な設定項目:
        - name
        - bundleIdPrefix
        - MARKETING_VERSION
        - CURRENT_PROJECT_VERSION
        - IPHONEOS_DEPLOYMENT_TARGET
        - SWIFT_VERSION
        - targets.TemplateApp.settings.PRODUCT_BUNDLE_IDENTIFIER
        - targets.TemplateAppTests.settings.PRODUCT_BUNDLE_IDENTIFIER
        - targets.TemplateAppUITests.settings.PRODUCT_BUNDLE_IDENTIFIER
    - 注意:
        - テンプレート名やバンドルID（例: TemplateApp, com.example.templateapp）は新しいプロジェクト名・構成に変更してください。
        - 他のパラメータも必要に応じて調整します。

2. Makefile
    - 主な設定項目:
        - LOCAL_SIMULATOR_NAME
        - LOCAL_SIMULATOR_OS
        - LOCAL_SIMULATOR_UDID
        - APP_BUNDLE_ID
        - APP_SCHEME
        - UNIT_TEST_SCHEME
        - UI_TEST_SCHEME
    - 注意:
        - パスや設定値はプロジェクトに合わせて調整してください。

3. 各 Info.plist（TemplateApp/Info.plist, TemplateAppTests/Info.plist, TemplateAppUITests/Info.plist）
    - 主な設定項目:
        - CFBundleIdentifier
        - バージョン情報
    - 注意:
        - プレースホルダー値（例: com.example.templateapp.uitests）はプロジェクトに合わせて変更します。
        - 初期値はテンプレート用です。

4. .swiftlint.yml
    - included/excluded のパスやテンプレート名（TemplateAppなど）を変更します。

5. .swiftformat
    - Swiftバージョン（--swiftversion）を指定します。
        - 例: --swiftversion 5.9

6. .github/workflows/ci-cd-pipeline.yml
    - name の値（ワークフローのタイトル）をプロジェクト名に合わせて調整します。
        - 例: Template App CI/CD Pipeline
