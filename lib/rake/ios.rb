namespace :deploygate do
  desc "Submit an archive to DeployGate"
  task :submit do
    config = App.config

    Rake::Task["archive"].invoke
    App.info "DeployGate", "Submit #{config.name}.ipa to DeployGate"
    app_path = "build/iPhoneOS-#{config.deployment_target}-#{config.build_mode.to_s.capitalize}/#{config.name}.ipa"
    message = ENV['message'] ? "-m \"#{ENV['message']}\"" : ""
    sh "dgate push #{config.deploygate.user_id} \"#{app_path}\" #{message}"
  end

  desc "Symbolicate a crash log"
  task :symbolicate do
    config = App.config
    crashlog_path = File.expand_path(ENV['file'] || "")
    if ENV['file'].to_s == "" || !File.exist?(crashlog_path) 
      App.fail "Usage: \"rake deploygate:symbolicate file=file_path_to_crashlog\""
    end

    symbolicatecrash = "#{config.xcode_dir}/Platforms/iPhoneOS.platform/Developer/Library/PrivateFrameworks/DTDeviceKitBase.framework/Versions/A/Resources/symbolicatecrash"
    dsym_path = App.config.app_bundle_dsym('iPhoneOS')
    sh "DEVELOPER_DIR=#{config.xcode_dir} #{symbolicatecrash} \"#{crashlog_path}\" \"#{dsym_path}\""
  end
end
