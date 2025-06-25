# TemplateApp

SwiftUIを使ったiOSアプリケーションテンプレートです。

## 特徴

- SwiftUI を使用した現代的なiOSアプリ開発
- XcodeGen でプロジェクト設定を管理
- SwiftLint でコード品質を保証
- SwiftFormat でコードスタイルを統一

## 必要な環境

- Xcode 14.0 以上
- iOS 15.0 以上
- Swift 5.0 以上

## セットアップ

1. 依存関係をインストール:
   ```bash
   mint bootstrap
   ```

2. Xcodeプロジェクトを生成:
   ```bash
   mint run xcodegen generate
   ```

3. Xcodeでプロジェクトを開く:
   ```bash
   open TemplateApp.xcodeproj
   ```

## プロジェクト構成

```
TemplateApp/
├── Views/           # SwiftUIビューファイル
├── Models/          # データモデル
├── ViewModels/      # ビューモデル
├── Resources/       # アセットとリソース
│   └── Assets.xcassets/
├── App.swift        # メインアプリエントリーポイント
└── Info.plist       # アプリ情報設定

# 設定ファイル
├── .swiftlint.yml   # SwiftLint設定
├── .swiftformat     # SwiftFormat設定
├── project.yml      # XcodeGen設定
├── Mintfile         # 依存関係管理
└── README.md        # プロジェクトドキュメント
```

## 必須設定

プロジェクト使用前に以下の設定ファイル内のプレースホルダーを置き換えてください：

### `.swiftlint.yml`
- `<SWIFT_VERSION>`: 例 "5.9"
- `<PATH_TO_SOURCES>`: 例 "TemplateApp"
- `<EXCLUDED_PATHS>`: 例 "Pods", "Frameworks", "Vendor", "ThirdParty"

### `.swiftformat`
- `<SWIFT_VERSION>`: 例 "5.9"
- `<PATH_TO_SOURCES>`: 例 "TemplateApp"
- `<EXCLUDED_PATHS>`: 例 "Pods", "Frameworks", "Vendor", "ThirdParty"

## 開発

### 手動実行

コマンドラインから直接実行することも可能です：

```bash
# SwiftLint
mint run swiftlint

# SwiftFormat  
mint run swiftformat .
```

### ライセンス

MIT License
