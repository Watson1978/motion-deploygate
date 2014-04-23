# encoding: utf-8

unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

class DeployGateConfig
  def initialize(config)
    @config = config
  end

  def sdk=(sdk)
    @sdk = sdk
    @config.vendor_project(
      sdk,
      :static,
      :products => ['DeployGateSDK'],
      :headers_dir => 'Headers'
    )
    @config.frameworks << 'SystemConfiguration'
    apply_patch
  end

  def apply_patch
    Dir.glob(File.join(@sdk, "Headers") + "/*.h") do |file|
      file = File.expand_path(file)
      data = File.read(file)
      new_data = []
      data.each_line do |line|
        # comment out "@property(nonatomic) DeployGateSDKOption options;" line
        if line.strip == "@property(nonatomic) DeployGateSDKOption options;"
          new_data << "// #{line}"
        else
          new_data << line
        end
      end

      new_data = new_data.join
      if data != new_data
        File.open(file, "w") do |io|
            io.write new_data
        end
      end
    end
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
