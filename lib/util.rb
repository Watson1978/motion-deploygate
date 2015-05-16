module MotionDeployGate
  module_function

  def platform
    Motion::Project::App.respond_to?(:template) ? Motion::Project::App.template : :ios
  end

  def android?
    platform == :android
  end
end
