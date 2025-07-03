# TemplateApp

SwiftUI ベースの iOS アプリ用テンプレートです

## カスタマイズの手順

1. project.yml  
   - `name` → アプリ名  
   - `bundleIdPrefix` → 固有のドメイン
   - `MARKETING_VERSION` → バージョン  
   - `IPHONEOS_DEPLOYMENT_TARGET` → 最小 OS バージョン

2. CI/CDの設定  
   - `.github/workflows/`
   - `.github/scripts/run-local-ci.sh`
   - Xcode のバージョンを変更