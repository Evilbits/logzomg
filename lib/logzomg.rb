require "logzomg/version"
require 'logger'
require 'date'

module Logzomg
  class Logger
    # TODO change this to proper file path
    LOG_PATH = File.expand_path('../../logs/', __FILE__)
    LEVELS = ['debug','info','warning','error','fatal']

    UnsupportedType = Class.new(StandardError)
    UnsupportedLevel = Class.new(StandardError)

    # @param {String} level
    # @param {Hash} options
    def initialize(level = 'warning', options = {})
      @level = level
    end 

    # Logs the message
    # @param {Hash} hash
    # @param {Hash} options
    def log(hash, *options)
      valid_hash?(hash) ? level(hash[:level]) : (raise UnsupportedType)
      hash = format_msg(hash)
      write(hash, *options)
    end 

    # Sets the log level
    # @param {String} level
    def level(level=nil)
      @level = level if valid_level?(level)
      self
    end

    # REMOVE AFTER DONE CODING
    def test
      l = Logzomg::Logger.new
      l.log({
              "msg": "Something is on the horizon!", 
              "level": "debug"
            })
      l.log({
              "msg": "Three acro-yoga enthusiasts have been spotted!", 
              "level": "info"
            })
      l.log({
              "msg": "They are coming closer!", 
              "level": "warning"
            })
      l.log({
              "msg": "I don\'t know how to handle them!!", 
              "level": "error"
            })
      l.log({
              "msg": "You have died", 
              "level": "fatal"
            })
    end  
  
    private
      # Writes the log message to the logfile
      # @param {String} msg
      # @param {Hash} options
      def write(msg, options={})
        options[:file] ? file = "/" + options[:file] : file = '/log.txt'
        File.open(LOG_PATH + file, 'a') {|f| f.write(msg) }
      end  

      # TODO handle strings longer than 150 chars
      # @param {hash} hash
      # @return {String}
      def format_msg(hash)
        str = ""
        str << add_msg_identifier(str)
        str << hash[:msg]
        str << right_align_date(hash[:msg])
        str << + " | " + DateTime.now.to_s + "\n"
        str
      end

      # Adds spaces to right align date
      # @param {String} msg
      # @return {String}
      def right_align_date(msg)
        " " * (150 - msg.length)  
      end

      # TODO prettify this by maybe making LEVELS a hash and giving the colors in the value?
      # Takes the message and adds color and the identifier at the start
      # @param {String} str
      # @return {String}
      def add_msg_identifier(str)
        if @level == 'debug'
          str += "\e[34mDEBU\e[0m"
        elsif @level == 'info'
          str += "\e[96mINFO\e[0m"
        elsif @level == 'warning'
          str += "\e[33mWARN\e[0m"
        elsif @level == 'error'
          str += "\e[31mERRO\e[0m"
        elsif @level == 'fatal'
          str += "\e[91mFATA\e[0m"
        end 
        str + " | "
      end 

      # Checks if message is hash since we need to handle it differently
      # @param {hash} hash
      # @return {Bool}
      def valid_hash?(hash)
        return hash.class == Hash ? true : false
      end 

      # Checks if the level value is valid (part of LEVELS)
      # @param {String} level
      # @return {Bool}
      def valid_level?(level)
        !level.nil? && LEVELS.any? { |l| l == level.downcase } ? (return true) : (raise UnsupportedLevel)
      end 
  end
end
