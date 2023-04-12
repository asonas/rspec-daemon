# RSpec::Daemon

rspec-daemon is a gem to run specs at high speed.

The original idea can be found at the following URL @cumet04
https://gist.github.com/cumet04/71d7d76310f7cb436c68b57a7c99aae3

## Installation

In your Gemfile

```
gem 'rspec-daemon', require: false
```

## Usage

```
$ cd YOUR_PROJECT
$ bundle ex rspec-daemon
```

```
$ echo 'spec/models/user_spec.rb' | nc -v 0.0.0.0 3002
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/asonas/rspec-daemon. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/asonas/rspec-daemon/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RSpec::Daemon project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/asonas/rspec-daemon/blob/master/CODE_OF_CONDUCT.md).
