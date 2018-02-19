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
