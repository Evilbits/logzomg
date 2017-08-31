require 'date'

# Default TextFormatter for logzomg.rb
# Allows color output to logfile

class TextFormatter
  MAX_CHAR = 150
  MAX_CHAR_FLOAT = 145.00   # There's some problems with float decimal precision. Keep this 5 below MAX_CHAR
  COLORS = {
    info:     "96",
    warning:  "33", 
    debug:    "34",
    error:    "91",
    fatal:    "31"
  }

  attr_accessor :with_color

  def initialize
    if block_given?
      yield(self)
    end
  end

  # Split the message into 145 char chunks. 
  # Prepend level. Append DateTime
  def format_msg(hash, level)
    @level = level                                        # Log level
    str = ""                                              # Final String we return. This is the one we add to
    str_keys_values = ""                                  # One long String in format "key: value  | key2: value2"
    s_msg = []                                            # Each index in this Array is the maximum allowed amount of chars on the screen
    
    str_keys_values += hash[:msg].to_s + "  |  "          # Add msg first

    # We loop over every key in the hash and format the key/value in the string format we want    
    hash.each do |key, value|
      if !key.to_s.eql?("level") && !key.to_s.eql?("msg") && !key.to_s.eql?("file")
        key = add_color_key(key) + ": " if with_color     # Add color to keys if with_color is set to true
        str_keys_values += "#{key} #{value}  "
      end
    end

    s_msg = split_msg(str_keys_values)                    # Split message incase it's MAX_CHAR+ chars
    
    s_msg.each do |n|
      puts n
    end

    count = 0                                             # Use to indent on 2nd+ iteration

    s_msg.each do |n|
      str += add_msg_identifier(str)
      text = count >= 1 ? " " + n : n                     # Indent if 2nd+ iteration
      str += text
      indented = count >= 1                               # Set indented to determine space amount
      str += right_align_date(n, hash, count+1, s_msg)
      str += " | " + add_date(count) + "\n"
      count += 1
    end
    
    str
  end


  private
    def add_date(count)
      count > 0 ? "" : DateTime.now.to_s
    end

    # Adds spaces to right align date depending on str length and row number
    # 
    # Since we add colouring to each key we're adding invisible characters
    # Each colour adds 9 extra characters so we have to handle this
    def right_align_date(msg, hash, itr, full_msgs)
      extra = 0
      # If msg is first don't right_align since there's always a line 2
      if msg == full_msgs.first && full_msgs.size > 1     # Triggers on first line of multiline
        extra = 0
      elsif itr == 1                                      # Triggers on first itr if it's one-line with args
        extra = 9 * get_size(hash)
      elsif itr == full_msgs.length && get_size(hash) > 0 # Triggers on last line of multiline msg
        extra = 9
      end


      s = itr > 1 ? MAX_CHAR - 2 : MAX_CHAR - 1
      " " * (s - msg.length + extra)
    end

    # Returns size but without certain keys that wont be displayed
    def get_size(hash)
      size = 0
      hash.keys.each do |n|
        size += 1 unless n.to_s.eql?("file") || n.to_s.eql?("level") || n.to_s.eql?("msg")
      end
      size
    end

    # Adds log level to start of log
    # Add color if color is true
    def add_msg_identifier(str)
      # Need a check since debug has a different identifier than the rest
      str = @level == 'debug' ? 'DBUG' : @level[0..3].upcase
      str = add_color_level(str) if with_color
      str += + " | "
    end 

    # Adds color to level if color is true
    def add_color_level(str)
      close_color = "\e[0m"
      str.prepend("\033[" + COLORS[@level.to_sym] + "m")
      str += close_color
    end

    # Adds color to hash key
    def add_color_key(key)
      "\033[" + COLORS[@level.to_sym] + "m" + key.to_s + "\e[0m"
    end

    # Splits the message
    # Substring using MAX_CHAR - 5 but not if in middle of a word
    def split_msg(msg)
      sub_end = MAX_CHAR - 5
      # Goes back to start of word if matches inside a word. If it matches inside a coloured key go back to start of word before colour
      arr = msg.scan(/.{0,#{Regexp.escape(sub_end.to_s)}}[^\\033\[33m\]a-z\\e\[0m$a-z.!?,;](?:\b|$)/mi)
      arr
    end 
end