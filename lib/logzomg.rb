require_relative 'formatters/text_formatter'
require "logzomg/version"

module Logzomg
  class Logger
    # TODO change this to proper file path
    LEVELS = ['debug','info','warning','error','fatal']

    UnsupportedType = Class.new(StandardError)
    UnsupportedLevel = Class.new(StandardError)

    attr_accessor :log_path

    def initialize(**args, &block)
      @log_path = get_log_path
      @level = args[:level] ? args[:level] : "warning"
      @formatter = args[:formatter] ? args[:formatter] : TextFormatter.new {|f| f.with_color = true}
      if block_given?
        yield(self)
        return
      end
    end 

    # First set level -> 
    # Format message -> 
    # Write message to file
    def log(hash)
      raise UnsupportedType, "Must be of type Hash" unless valid_hash?(hash)
      level(hash[:level]) if hash.has_key?(:level)        # Use default if not included
      msg = @formatter.format_msg(hash, @level)
      write(hash, msg)
    end 

    # Sets the log level
    def level(level)
      raise UnsupportedLevel, "Level " + level + " is not a valid level" unless valid_level?(level)
      @level = level
      self
    end

    # REMOVE AFTER DONE CODING
    def test
      self.log({
                msg:      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam ipsum dui, luctus ac velit nec, imperdiet elementum turpis." +
                "Pellentesque velit tellus, ultricies non mauris at, semper rhoncus enim. Duis blandit arcu aliquam, sollicitudin leo quis, feugiat orci." + 
                "Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed et tortor vel lectus convallis posuere ac vel lacus." + 
                "Praesent vestibulum cursus ipsum vel elementum. Fusce elit enim, sollicitudin id sem consequat, molestie accumsan mi. Aliquam vehicula urna tortor," + 
                "sit amet laoreet lacus pulvinar eu. Ut imperdiet vitae neque eu consectetur. Nam ac lacus finibus, fringilla neque ac, maximus ligula. Duis ullamcorper," + 
                "felis sit amet luctus vehicula, sapien est dictum lorem, nec blandit nunc mi id enim. Curabitur quis laoreet erat. Maecenas varius cursus blandit." + 
                "felis sit amet luctus vehicula, sapien est dictum lorem, nec blandit nunc mi id enim. Curabitur quis laoreet erat. Maecenas varius cursus blandit." + 
                "felis sit amet luctus vehicula, sapien est dictum lorem, nec blandit nunc mi id enim. Curabitur quis laoreet erat. Maecenas varius cursus blandit." + 
                "felis sit amet luctus vehicunec blandit nunc mi id enim. Curabitur quis laoreet erat. Maecenas varius cursus blandit." + 
                "felis sit amet luctus vehicula, sapien est dictum lorem, nec blandit nunc mi id enim. Curabitur quis laoreet erat. Maecenas varius cursus blandit." + 
                "felis sit amet luctus vehicula, sapien est ditur quis laoreet erat. Maecenas varius cursus blandit." + 
                "felis sit amet luctus vehicula, sapien est dictum lorem, nec blandit nunc mi id enim. Curabitur quis laoreet erat. Maecenas varius cursus blandit." + 
                "felis sit amet luctus vehicula, sapien est dictum lorem, nec blandit nunc mi id enim. Curabitur quis laoreet erat. Maecenas varius cursus blandit." + 
                "felis sit amet luctus vehicula, sapien est dictum lorem, nec blandit nunc mi id enim. Curabitur quis laoreet erat. Maecenas varius cursus blandit." + 
                "felis sit amet luctus vehicula, sapien est dictum lorem, nec blandit nunc mi id enim. Curabitur quis laoreet erat. Maecenas varius cursus blandit." + 
                "felis sit amet luctus vehicula, sapien est dictum lorem, nec blandit nunc mi id enim. Curabitur quis laoreet erat. Maecenas varius cursus blandit." + 
                "Aliquam eleifend mauris ut nisl mollis, quis placerat nisi bibendum.",
                long:     true,
                what:     true,
                bugged:   false,
                nigga:    "what",
                level:    "debug"
              })
      self.log({
                msg:      "This is very long This is very long This is very long This is very long This is very long This is very long This is very long This is very long This is very long This is very long This is very long This is very long This is very long ",
                long:     true,
                what:     true,
                bugged:   false,
                nigga:    "what",
                level:    "debug"
              })
      self.log({
                msg:      "Something is on the horizon!", 
                spotted:  "unknown",
                level:    "debug"
              })
      self.log({
                number: 3,
                entity:   "Acro-yoga enthusiasts",
                wild:     true,
                msg:      "Something has been spotted!", 
                damn:     "son",
                damn2:    "son",
                damn3:    "son",
                object:   Object.new,
                damn4:    "son",
                damn5:    "son",
                level:    "info"              
              })
      self.log({
                msg:      "They are coming closer!", 
                speed:    "5km/t",
                level:    "warning"
              })
      self.log({
                msg:      "I don't know how to handle them!!", 
                omg:      true,
                level:    "error"
              })
      self.log({
                dead:     true,
                msg:      "You have died", 
                level:    "fatal"
              })
    end  
  
    private
      # Writes the log message to the logfile 
      # If given one in hash[:file] use that
      def write(hash, msg)
        file = hash.has_key?(:file) ? "/" + hash[:file] : '/log.txt'
        File.open(@log_path + file, 'a') {|f| f.write(msg) }
      end  

      # Checks if message is hash
      def valid_hash?(hash)
        return hash.is_a?(Hash)
      end 

      # Checks if the level value is valid (part of LEVELS)
      def valid_level?(level)
        return !level.nil? && LEVELS.any? { |l| l == level.downcase }
      end 

      def get_log_path
        if defined?(Rails)
          File.expand_path(Rails.root.to_s + '/log/')
        else
          File.expand_path('log/')
        end
      end
  end
end