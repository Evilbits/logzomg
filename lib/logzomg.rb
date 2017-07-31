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

    # First set level -> Format message -> Write message to file
    # @param {Hash} hash
    def log(hash)
      # Raise exception if hash isn't a Hash
      raise UnsupportedType unless valid_hash?(hash)
      level(hash[:level])
      msg = format_msg(hash[:msg])
      write(hash, msg)
    end 

    # Sets the log level
    # @param {String} level
    def level(level=nil)
      # Raise exception if level isn't in LEVELS
      raise raise UnsupportedLevel unless valid_level?(level)
      @level = level
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
              "msg": "This is a really really really really really really really really really " +
                      "really really really really really really really really really really really " +
                      "really really really really really really debug message", 
              "level": "debug"
            })
      l.log({
              "msg": "Three wild acro-yoga enthusiasts have been spotted!", 
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
      # Writes the log message to the logfile. If given one in hash[:file] use that
      # @param {String} msg
      def write(hash, msg)
        hash.has_key?(:file) ? file = "/" + hash[:file] : file = '/log.txt'
        File.open(LOG_PATH + file, 'a') {|f| f.write(msg) }
      end  

      # Split the message into 145 char chunks. Prepend level. Append DateTime
      # @param {String} msg
      # @return {String}
      def format_msg(msg)
        str = ""
        s_msg = split_msg(msg)                                # Split message incase it's 150+ chars
        count = 0                                             # Use to indent on n+1
        s_msg.each do |n|
          str += add_msg_identifier(str)
          count >= 1 ? (text = "  " + n) : text = n           # Indent if n+1 loop
          str += text
          count >= 1 ? indented = true : indented = false     # Set indented to determine space amount
          str += right_align_date(n, indented)
          str += " | " + DateTime.now.to_s + "\n"
          count += 1
        end
        str
      end

      # Adds spaces to right align date depending on str length and row number
      # @param {String} msg
      # @param {Bool} indented
      # @return {String}
      def right_align_date(msg, indented)
        indented ? s = 148 : s = 150
        " " * (s - msg.length)  
      end

      # TODO prettify this by maybe making LEVELS a hash and giving the colors in the value?
      # Takes the message and adds color and the identifier at the start
      # @param {String} str
      # @return {String}
      def add_msg_identifier(str)
        if @level == 'debug'
          "\e[34mDEBU\e[0m" + " | "
        elsif @level == 'info' 
          "\e[96mINFO\e[0m" + " | "
        elsif @level == 'warning'
          "\e[33mWARN\e[0m" + " | "
        elsif @level == 'error'
          "\e[31mERRO\e[0m" + " | "
        elsif @level == 'fatal'
          "\e[91mFATA\e[0m" + " | "
        end 
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
        return !level.nil? && LEVELS.any? { |l| l == level.downcase } ? true : false
      end

      # Splits the message every 150 chars to make everything look prettier
      # @param {String} msg
      # @return {Array}
      def split_msg(msg)
        arr = []
        start = 0
        ending = 145
        msg.length > 150 ? (c = ((msg.length).to_f/150.00).ceil) : c = 1
        (1..c).each do |n|
          arr << msg[start,ending]
          start += 146
          ending += 145
        end
        arr  
      end  
  end
end
