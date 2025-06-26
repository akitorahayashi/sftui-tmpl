# TemplateApp

SwiftUI ベースの iOS アプリ用テンプレートです

## カスタマイズ手順

1. project.yml  
   - `name` → アプリ名  
   - `bundleIdPrefix` → 企業ドメインなど  
   - `MARKETING_VERSION` → バージョン  
   - `IPHONEOS_DEPLOYMENT_TARGET` → 対応 OS バージョン

2. Package.swift  
   - `dependencies` に必要なパッケージを追加  
   - `targets.<ターゲット名>.dependencies` にパッケージ名を追加

3. ツール設定  
   - `.swiftlint.yml` と `.swiftformat` 内の  
     `<SWIFT_VERSION>`, `<PATH_TO_SOURCES>`, `<EXCLUDED_PATHS>`