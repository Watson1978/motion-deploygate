# motion-deploygate

DeployGate integration for RubyMotion projects

## Installation

Add this line to your application's Gemfile:

    gem 'motion-deploygate'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install motion-deploygate

## Usage

1. Download the DeployGate SDK for iOS from https://deploygate.com/docs/ios_sdk and unpack it. Then, copy `DeployGateSDK.framework` into `vendor` directory of your RubyMotion project. Create the `vendor` directory if it does not exist.

2. Configure the DeployGate SDK in your `Rakefile`. Set up `user_id`, `api_key`, `user_infomation` and `sdk` variables as following.

```ruby
Motion::Project::App.setup do |app|
  ...
  app.deploygate.user_id = '<user_id>'
  app.deploygate.api_key = '<api_key>'
  app.deploygate.user_infomation = true # or false
  app.deploygate.sdk = 'vendor/DeployGateSDK.framework'
  ...
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
