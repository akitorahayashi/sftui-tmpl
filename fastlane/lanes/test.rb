# fastlane/lanes/test.rb
# Test-related lanes and helpers

# === Test Lanes ===
desc "Build for testing"
lane :build_for_testing do |options|
  configuration = options[:configuration] || CONFIGURATIONS[:debug]
  derived_data_path = "#{TEST_DERIVED_DATA_PATH}/#{configuration}"

  passed_xcargs = options[:xcargs] || ""

  xcargs_items = []
  if configuration == CONFIGURATIONS[:release]
    xcargs_items << "ENABLE_TESTABILITY=YES"
  end
  
  xcargs_items << passed_xcargs unless passed_xcargs.empty?
  xcargs = xcargs_items.join(' ')

  get_simulator_info(options)
  udid = Actions.lane_context[:SIMULATOR_UDID]
  scan_args = {
    project: PROJECT_PATH,
    scheme: SCHEMES[:app],
    destination: "platform=iOS Simulator,id=#{udid}",
    derived_data_path: derived_data_path,
    configuration: configuration,
    build_for_testing: true,
    clean: true,
    buildlog_path: TEST_LOGS_PATH,
    suppress_xcode_output: true
  }
  scan_args[:xcargs] = xcargs unless xcargs.empty?
  scan(**scan_args)
end

desc "Run unit tests"
lane :unit_test do |options|
  test_with_scheme(scheme: SCHEMES[:unit_test], result_path: UNIT_TEST_RESULT_PATH, **options)
end

desc "Run unit tests without building"
lane :unit_test_without_building do |options|
  test_with_scheme(scheme: SCHEMES[:unit_test], result_path: UNIT_TEST_RESULT_PATH, test_without_building: true, **options)
end

desc "Run integration tests"
lane :intg_test do |options|
  test_with_scheme(scheme: SCHEMES[:intg_test], result_path: INTG_TEST_RESULT_PATH, **options)
end

desc "Run integration tests without building"
lane :intg_test_without_building do |options|
  test_with_scheme(scheme: SCHEMES[:intg_test], result_path: INTG_TEST_RESULT_PATH, test_without_building: true, **options)
end

desc "Run UI tests"
lane :ui_test do |options|
  test_with_scheme(scheme: SCHEMES[:ui_test], result_path: UI_TEST_RESULT_PATH, **options)
end

desc "Run UI tests without building (xcodebuild test-without-building)"
lane :ui_test_without_building do |options|
  test_with_scheme(scheme: SCHEMES[:ui_test], result_path: UI_TEST_RESULT_PATH, test_without_building: true, **options)
end

desc "Run all tests (Unit, UI, Intg)"
lane :test_all do
  build_for_testing
  unit_test_without_building
  intg_test_without_building
  ui_test_without_building
end

# === Private Lanes ===

desc "Get simulator information based on environment"
private_lane :get_simulator_info do |options|
  udid = options[:udid]
  if udid.nil? || udid.empty?
    if is_ci?
      udid = sh("xcrun simctl list devices available 'iPhone' | grep -Eo '[A-F0-9-]{36}' | head -n 1").strip
      if udid.nil? || udid.empty?
        UI.user_error!("Could not get UDID for an available iPhone simulator in the CI environment")
      end
    else
      UI.user_error!("UDID is not specified. Please pass the udid option from the justfile.")
    end
  end
  Actions.lane_context[:SIMULATOR_UDID] = udid
end

desc "Run test for a given scheme (optionally without building)"
private_lane :test_with_scheme do |options|
  result_path = File.expand_path(options[:result_path], Dir.pwd)
  sh("rm -rf \"#{result_path}\"")
  get_simulator_info(options)
  udid = Actions.lane_context[:SIMULATOR_UDID]
  
  configuration = options[:configuration] || CONFIGURATIONS[:debug]
  derived_data_path = "#{TEST_DERIVED_DATA_PATH}/#{configuration}"
  
  passed_xcargs = options[:xcargs] || ""

  scan_args = {
    project: PROJECT_PATH,
    scheme: options[:scheme],
    destination: "platform=iOS Simulator,id=#{udid}",
    derived_data_path: derived_data_path,
    result_bundle_path: result_path,
    code_coverage: false,
    output_types: "xcresult",
    clean: false,
    buildlog_path: TEST_LOGS_PATH,
    suppress_xcode_output: true
  }

  scan_args[:xcargs] = passed_xcargs unless passed_xcargs.empty?
  scan_args[:test_without_building] = options[:test_without_building] if options[:test_without_building]

  begin
    scan_args[:fail_build] = false
    scan(**scan_args)
    UI.success("✅ Test successful for scheme '#{options[:scheme]}' (output suppressed)")
  rescue => ex
    log_path = lane_context[SharedValues::SCAN_BUILDLOG_PATH]
    UI.error("❌ Test failed. Showing last 100 lines from log: #{log_path}")
    
    if log_path && File.exist?(log_path)
      UI.message(File.read(log_path).lines.last(100).join)
    else
      UI.error("Could not find log file at: #{log_path}")
    end
    raise ex
  end
end
