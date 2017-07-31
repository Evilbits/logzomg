# Logzomg

Logzomg is currently in production.

Logzomg is a gem that utilises the default Rails Logger but adds extra functionality.
The main feature of Logzomg is it's integration with the Asana API.
In the future it will automatically create tasks if critical errors happen.
My goal is also to implement automatic emailing at some point.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'logzomg'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install logzomg

## Usage

Logzomg currently supports varying levels of logging intensity.

`
Debug
Info
Warn
Error
Fatal
`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Evilbits/logzomg


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

