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

Start the daemon process by running `rspec-daemon` in the directory where you would run `rspec`.

```
$ cd YOUR_PROJECT
$ bundle ex rspec-daemon
Listening on tcp://0.0.0.0:3002
```

To run specs, use the `rspeccc` client tool.

```
$ bundle ex rspeccc spec/models/user_spec.rb # arguments are passed to rspec

User
  is healthy

Finished in 0.00136 seconds (files took 36.25 seconds to load)
1 example, 0 failures
```

Alternatively, standard utilites such as `nc` may be used.

```
$ echo 'spec/models/user_spec.rb' | nc -v 0.0.0.0 3002
```

By default, `rspec-daemon` will run on port `3002`. You can adjust the port by passing `--port` to `rspec-daemon` or setting the `RSPEC_DAEMON_PORT` environment variable.

### Auto-reloading application code in Rails

If properly configured, rspec-daemon will automatically reload your application code (you probably want this behavior).
Add the following code to `config/initializers/rspec_daemon.rb`:

```ruby
# rspec-daemon exposes RSPEC_DAEMON=1
if Rails.env.test? && ENV['RSPEC_DAEMON']
  Rails.configuration.enable_reloading = true
end
```

If autoreloading is not configured, you'd need to restart `rspec-daemon` every time you change code under `app/`.
Spec code (under `spec/`) will be always reloaded regardless of this setting.

## Editor integration

### Vim/Neovim

Add a key binding of your preference to your `.vimrc` or `init.vim`.

```vim
" Run specs under the current cursor line
nnoremap <Leader>h :execute '!bundle exec rspeccc ' . expand('%:p') . ':' . line('.')<CR>
```

If you are using [rspec.vim](https://github.com/thoughtbot/vim-rspec), you may want to configure `g:rspec_command`.

```vim
" For rspec.vim users
let g:rspec_command = "!bundle exec rspeccc {spec}"
```

### Visual Studio Code

Tasks are a nice way to launch `rspeccc`.
Here is an example `tasks.json` configuration which runs specs under the current cursor location:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "rspec-remote: Cursor context",
      "group": "test",
      "type": "shell",
      "command": "bundle exec rspeccc ${relativeFile}:${lineNumber}"
    }
  ]
}
```

Adding a keybindings.json entry for your Task is also recommendable.

```json
[
  {
    "key": "cmd+h",
    "command": "workbench.action.tasks.runTask",
    "args": "rspec-remote: Cursor context"
  }
]
```

Refer to Visual Studio Code's documentation ([Integrate with External Tools via Tasks](https://go.microsoft.com/fwlink/?LinkId=733558)) for further customization.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/asonas/rspec-daemon. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/asonas/rspec-daemon/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RSpec::Daemon project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/asonas/rspec-daemon/blob/master/CODE_OF_CONDUCT.md).
