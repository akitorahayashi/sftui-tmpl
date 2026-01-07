# fastlane/lanes/sign.rb
# Signing-related lanes

# === Signing-only Lanes ===
desc "Sign debug archive for development"
lane :sign_debug_development do
  sign_archive(
    archive_path: DEBUG_ARCHIVE_PATH,
    export_method: EXPORT_METHODS[:development],
    configuration: CONFIGURATIONS[:debug]
  )
end

desc "Sign release archive with specified export method (development, app_store, ad_hoc, enterprise)"
lane :sign_release do |options|
  export_method = options[:export_method]
  sign_archive(
    archive_path: RELEASE_ARCHIVE_PATH,
    export_method: export_method,
    configuration: CONFIGURATIONS[:release]
  )
end

# === Private Lanes ===

desc "Sign and export archive with specified export method"
private_lane :sign_archive do |options|
  export_method = options[:export_method]
  archive_path = options[:archive_path]
  configuration = options[:configuration]
  
  export_base = case configuration
                when CONFIGURATIONS[:release] then RELEASE_EXPORT_BASE
                when CONFIGURATIONS[:debug] then DEBUG_EXPORT_BASE
                else UI.user_error!("Unknown configuration: #{configuration}")
                end

  build_app(
    project: PROJECT_PATH,
    scheme: SCHEMES[:app],
    archive_path: archive_path,
    export_method: export_method,
    skip_build_archive: true,
    output_directory: "#{export_base}/#{export_method}",
    export_team_id: ENV['TEAM_ID']
  )
end
