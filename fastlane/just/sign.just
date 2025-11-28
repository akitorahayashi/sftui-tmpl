# ==============================================================================
# Signing (Fastlane)
# ==============================================================================

# Sign debug archive for development
sign-debug-development:
    @bundle exec fastlane sign_debug_development

# Sign release archive for development
sign-release-development:
    @bundle exec fastlane sign_release export_method:development

# Sign release archive for App Store
sign-release-app-store:
    @bundle exec fastlane sign_release export_method:app_store

# Sign release archive for Ad Hoc
sign-release-ad-hoc:
    @bundle exec fastlane sign_release export_method:ad_hoc

# Sign release archive for Enterprise
sign-release-enterprise:
    @bundle exec fastlane sign_release export_method:enterprise
