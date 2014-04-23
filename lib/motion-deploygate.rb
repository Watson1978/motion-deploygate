# encoding: utf-8

unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

class DeployGateConfig
  def initialize(config)
    @config = config
  end

  def sdk=(sdk)
    @config.vendor_project(
      sdk,
      :static,
      :products => ['DeployGateSDK'],
      :headers_dir => 'Headers'
    )
    @config.frameworks << 'SystemConfiguration'
  end
end

module Motion; module Project; class Config
  variable :deploygate

  def deploygate
    @deploygate ||= DeployGateConfig.new(self)
  end

end; end; end

lib_dir_path = File.dirname(File.expand_path(__FILE__))
Motion::Project::App.setup do |app|
  app.files.unshift(Dir.glob(File.join(lib_dir_path, "project/**/*.rb")))
end
