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
