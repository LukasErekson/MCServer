# mc_server

mc_server is a gem that creates an instance of a Minecraft Java Edition server to send commands to through Ruby. Each instance stores the PID, the output, and the input for the server process.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mc_server'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install mc_server

## Usage

```ruby
server = mc_server.new

server.path #=> ~/Minecraft_Server

server.start #=> true

server.pid #=> 645851

server.command '/op Grian' #=> true

server.command '/kick Skeppy Trolling' #=> true

server.stop #=> true
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lukaserekson/mc_server. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/lukaserekson/mc_server/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the mc_server project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/lukaserekson/mc_server/blob/main/CODE_OF_CONDUCT.md).
