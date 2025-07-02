# TemplateApp

SwiftUI ベースの iOS アプリ用テンプレートです

## カスタマイズの手順

1. project.yml  
   - `name` → アプリ名  
   - `bundleIdPrefix` → 固有のドメイン
   - `MARKETING_VERSION` → バージョン  
   - `IPHONEOS_DEPLOYMENT_TARGET` → 最小 OS バージョン

2. Package.swift  
   - `dependencies` に必要なパッケージを追加  
   - `targets.<ターゲット名>.dependencies` にパッケージ名を追加

3. ツールの設定  
   - `.swiftlint.yml` と `.swiftformat` 内の  
     `<SWIFT_VERSION>`, `<PATH_TO_SOURCES>`, `<EXCLUDED_PATHS>`

4. CI/CDの設定  
   - `.github/workflows/`
   - `.github/scripts/run-local-ci.sh`
   - Xcode のバージョンを変更