# Logzomg

**Logzomg is NOT in development. No features will be added and no bugs will be fixed**

An easy to use and modern logging gem made for Rails APIs.

![Terminal output](http://i.imgur.com/SFvnXXm.png)

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

The logger takes a hash in and formats the key-value pairs. Msg must always be included and will always be shown first.

You can instantiate the logger and give it X amount of key/value pairs.

```ruby
def log
  l = Logzomg::Logger.new
  l.log({
    number: 3,
    entity: "Acro-yoga enthusiasts",
    wild: true,
    msg: "Have been spotted!", 
    damn: "son",
    level: "info",                       # Optional. Sets log level. Default is warning
    file: "help.txt"                     # Optional. Sets name of file to log to. Default is log.txt
  })
end  
```

By default Logzomg color codes the logging levels when viewed in a terminal. If you want to turn this off you can instead pass a TextFormatter when instantiating the logger.

The TextFormatter takes a hash of options.

```ruby
def logger
  Logzomg::Logger.new(formatter: TextFormatter.new { |f|
    f.with_color = true
    f.short_date  = true
  })
end
```


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

