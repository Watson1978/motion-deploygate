namespace :deploygate do
  desc "Submit an archive to DeployGate"
  task :submit do
    config = App.config

    Rake::Task["build"].invoke
    App.info "DeployGate", "Submit #{config.name}.apk to DeployGate"
    app_path = "build/#{config.build_mode.to_s.capitalize}-#{config.api_version}/#{config.name}.apk"
    message = ENV['message'] ? "-m \"#{ENV['message']}\"" : ""
    sh "dgate push #{config.deploygate.user_id} \"#{app_path}\" #{message}"
  end
end
