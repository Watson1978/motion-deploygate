module DeployGateAndroid
  def user_id=(id)
    @user_id = id
  end

  def sdk=(sdk)
    @sdk = sdk
    @config.vendor_project(
      :jar => sdk
    )
  end
end
