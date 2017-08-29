require_relative 'formatters/text_formatter'
require "logzomg/version"

module Logzomg
  class Logger
    # TODO change this to proper file path
    LOG_PATH = File.expand_path('../../logs/', __FILE__)
    LEVELS = ['debug','info','warning','error','fatal']

    UnsupportedType = Class.new(StandardError)
    UnsupportedLevel = Class.new(StandardError)

    def initialize(formatter=TextFormatter.new)
      @level = 'warning'
      @formatter = formatter
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
              msg: "Something is on the horizon!", 
              level: "debug"
            })
      self.log({
              msg: "This is a really really really really really really really really really " +
                      "really really really really really really really really really really really " +
                      "really really really really really really debug message", 
              level: "debug"
            })
      self.log({
                number: 3,
                entity: "Acro-yoga enthusiasts",
                wild: true,
                msg: "Have been spotted!", 
                damn: "son",
                level: "info"              
              })
      self.log({
              msg: "They are coming closer!", 
              level: "warning"
            })
      self.log({
              msg: "I don\'t know how to handle them!!", 
              level: "error"
            })
      self.log({
              msg: "You have died", 
              level: "fatal"
            })
    end  
  
    private
      # Writes the log message to the logfile 
      # If given one in hash[:file] use that
      def write(hash, msg)
        file = hash.has_key?(:file) ? "/" + hash[:file] : '/log.txt'
        File.open(LOG_PATH + file, 'a') {|f| f.write(msg) }
      end  

      # Checks if message is hash
      def valid_hash?(hash)
        return hash.class == Hash
      end 

      # Checks if the level value is valid (part of LEVELS)
      def valid_level?(level)
        return !level.nil? && LEVELS.any? { |l| l == level.downcase }
      end 
  end
end