# encoding: utf-8

unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

require_relative 'util'
require_relative 'ios'
require_relative 'android'

if MotionDeployGate.android?
  require_relative 'rake/android'
else
  require_relative 'rake/ios'
end

class DeployGateConfig
  attr_reader :user_id

  if MotionDeployGate.android?
    include DeployGateAndroid
  else
    include DeployGateIOS
  end

  def initialize(config)
    @config = config
    @user_infomation = false
  end
end

module Motion; module Project; class Config
  variable :deploygate

  def deploygate
    @deploygate ||= DeployGateConfig.new(self)
  end

end; end; end
