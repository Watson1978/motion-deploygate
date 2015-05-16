# motion-deploygate

DeployGate integration for RubyMotion projects

## Installation

Add this line to your application's Gemfile:

    gem 'motion-deploygate'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install motion-deploygate

## Setup

### iOS

1. Download the DeployGate SDK for iOS from https://deploygate.com/docs/ios_sdk and unpack it. Then, copy `DeployGateSDK.framework` into `vendor` directory of your RubyMotion project. Create the `vendor` directory if it does not exist.

2. Configure the DeployGate SDK in your `Rakefile`. Set up `user_id`, `api_key` and `sdk` variables as following.

```ruby
Motion::Project::App.setup do |app|
  ...
  app.development do
    app.deploygate.user_id = '<user_id>'
    app.deploygate.api_key = '<api_key>'
    app.deploygate.sdk = 'vendor/DeployGateSDK.framework'
  end
  ...
end
```

#### User authentication

If you would enable this feature, the testers can receive a notification when you will submit a new version to DeployGate.
Set up `user_infomation` and `url_scheme` variables to use the user authentication in your `Rakefile`.

```ruby
Motion::Project::App.setup do |app|
  ...
  app.development do
    app.deploygate.user_id = '<user_id>'
    app.deploygate.api_key = '<api_key>'
    app.deploygate.user_information = true
    app.deploygate.url_scheme = "deploygate.XXXXXXXXXXXX"
    app.deploygate.sdk = 'vendor/DeployGateSDK.framework'
  end
  ...
end
```

Then, add `application:didFinishLaunchingWithOptions:` method in your `AppDelegate` like the following. (It will be generated automatically since ver 0.4)

```ruby
class AppDelegate
  def application(application, openURL:url, sourceApplication:sourceApplication, annotation:annotation)
    return DeployGateSDK.sharedInstance.handleOpenUrl(url, sourceApplication:sourceApplication, annotation:annotation)
  end

  ...
end
```

### Android

Now, it can't use the feature of DeployGate Android SDK (see [#2](https://github.com/Watson1978/motion-deploygate/issues/2)).

1. Configure in order to submit app to DeployGate in your `Rakefile`. Set up `user_id` variables as following.

```ruby
Motion::Project::App.setup do |app|
  ...
  app.development do
    app.deploygate.user_id = '<user_id>'
  end
  ...
end
```


## Usage

### Submit your app to DeployGate

```
% rake deploygate:submit
% rake deploygate:submit message="test version"
```

The `message` parameter is optional, and its content will be used as the description of submission.

### Symbolicate a crashlog (iOS only)

Download a crashlog from DeployGate then run the following command to symbolicate a crashlog.

```
% rake deploygate:symbolicate file=file_path_to_crashlog
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
