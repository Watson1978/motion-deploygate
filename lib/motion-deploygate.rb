# encoding: utf-8

unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

class DeployGateConfig
  attr_reader :user_id

  def initialize(config)
    @config = config
    @user_infomation = false
  end

  def user_id=(id)
    @user_id = id
  end

  def api_key=(key)
    @api_key = key
  end

  def user_infomation=(bool)
    @user_infomation = bool
  end
  alias :user_information= :user_infomation=

  def url_scheme=(scheme)
    @config.info_plist['CFBundleURLTypes'] = [
      {
        'CFBundleURLName'    => @config.identifier,
        'CFBundleURLSchemes' => [scheme]
      }
    ]
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
    create_launcher
    apply_patch
  end

  private

  def create_launcher
    return unless @user_id && @api_key

    launcher_code = <<EOF
# This file is automatically generated. Do not edit.

if Object.const_defined?('DeployGateSDK') and !UIDevice.currentDevice.model.include?('Simulator')
  NSNotificationCenter.defaultCenter.addObserverForName(UIApplicationDidFinishLaunchingNotification, object:nil, queue:nil, usingBlock:lambda do |notification|
    DeployGateSDK.sharedInstance.launchApplicationWithAuthor('#{@user_id}', key:'#{@api_key}', userInfomationEnabled:#{@user_infomation})
  end)

  class #{@config.delegate_class}
    unless #{@config.delegate_class}.method_defined?("application:openURL:sourceApplication:annotation:")
      def application(application, openURL:url, sourceApplication:sourceApplication, annotation:annotation)
        return DeployGateSDK.sharedInstance.handleOpenUrl(url, sourceApplication:sourceApplication, annotation:annotation)
      end
    end
  end

end
EOF
    launcher_file = './app/deploygate_launcher.rb'
    if !File.exist?(launcher_file) or File.read(launcher_file) != launcher_code
      File.open(launcher_file, 'w') { |io| io.write(launcher_code) }
    end
    @config.files.unshift(launcher_file)
  end

  def apply_patch
    Dir.glob(File.join(@sdk, "Headers") + "/*.h") do |file|
      file = File.expand_path(file)
      data = File.read(file)
      new_data = []
      data.each_line do |line|
        # replace "typedef enum" declaration to avoid http://hipbyte.myjetbrains.com/youtrack/issue/RM-479
        if line.strip == "typedef enum DeployGateSDKOption : NSUInteger {"
          new_data << "typedef enum DeployGateSDKOption {\n"
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

namespace :deploygate do
  desc "Submit an archive to DeployGate"
  task :submit do
    config = App.config

    Rake::Task["archive"].invoke
    App.info "DeployGate", "Submit #{config.name}.ipa to DeployGate"
    app_path = "build/iPhoneOS-#{config.deployment_target}-#{config.build_mode.to_s.capitalize}/#{config.name}.ipa"
    message = ENV['message'] ? "-m \"#{ENV['message']}\"" : ""
    sh "/usr/local/bin/dgate push #{config.deploygate.user_id} \"#{app_path}\" #{message}"
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
