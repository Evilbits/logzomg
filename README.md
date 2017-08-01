# Logzomg

An easy to use and lightweight logging gem for Ruby.

![Terminal output](http://i.imgur.com/pyfbspR.png)

Logzomg currently supports varying levels of severity.

`
Debug
`
`
Info
`
`
Warn
`
`
Error
`
`
Fatal
`

## Usage

You can instantiate the logger and use it like so:

```ruby
def log
  l = Logzomg::Logger.new
  l.log({
          "msg": "Frank took the last coffee and forgot to make some new. Fire him?", 
          "level": "info",                                    # Optional. Sets log level. Default is warning
          "file": "frank.txt"                                 # Optional. Sets name of file to log to. Default is log.txt
        })
end  
```

By default Logzomg color codes the logging levels when viewed in a terminal. If you want to turn this off you can instead pass a TextFormatter when instantiating the logger.

The TextFormatter takes a hash of options.

`
  Logzomg::Logger.new(TextFormatter.new({with_colors: false}))
`

Currently Logzomg only supports logging as plaintext. Soon it will support logging as JSON as well.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'logzomg'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install logzomg

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Evilbits/logzomg


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

