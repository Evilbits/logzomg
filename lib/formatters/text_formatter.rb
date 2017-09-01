require 'date'

class TextFormatter
  MAX_CHAR = 130
  MAX_CHAR_FLOAT = 125.00   # There's some problems with float decimal precision. Keep this 5 below MAX_CHAR
  COLORS = {
    info:     "96",
    warning:  "33", 
    debug:    "34",
    error:    "91",
    fatal:    "31"
  }

  attr_accessor :with_color, :short_date

  def initialize
    if block_given?
      yield(self)
    end
  end

  # Split the message into 145 char chunks. 
  # Prepend level. Append DateTime
  def format_msg(hash, level)
    @level = level                                        # Log level
    str = ""                                              # Final String we return. We keep appending to this
    count = 0                                             # Use to indent on 2nd+ iteration

    str_keys_values = add_key_values_to_str(hash)
    s_msg           = split_msg(str_keys_values)          # Split message incase it's MAX_CHAR+ chars

    s_msg.each do |n|
      str += count == 0 ? "#{add_log_level(str)}#{get_date} | " : "#{add_log_level(str)}"
      str += count == 0 ? "#{n}\n" : " " * (get_date.length) + " | #{n}\n" # Indent if 2nd+ iteration
      count += 1
    end
    str
  end

  private
    def get_date
      date = short_date ? DateTime.now.strftime('%b-%e %H:%M:%S') : DateTime.now.to_s
    end

    # Creates a string with format "msg: "Blabla" | key: value  key2: value2" we can split into array indices afterwards
    def add_key_values_to_str(hash)
      str_keys_values = ""                                # One long String in format 

      str_keys_values += hash[:msg].to_s + " | "          # Add msg first
      # We loop over every key in the hash and format the key/value in the string format we want    
      hash.each do |key, value|
        if !key.to_s.eql?("level") && !key.to_s.eql?("msg") && !key.to_s.eql?("file")
          key = "#{add_color_key(key)}" if with_color     # Add color to keys if with_color is set to true
          str_keys_values += "#{key}: #{value}  "
        end
      end
      str_keys_values
    end

    # Adds log level to start of log
    # Add color if color is true
    def add_log_level(str)
      # Need a check since debug has a different identifier than the rest
      str = @level == 'debug' ? 'DBUG' : @level[0..3].upcase
      str = add_color_key(str) if with_color
      str += + " | "
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
      msg.scan(/.{0,#{Regexp.escape(sub_end.to_s)}}[\\033\[0-90-9m\]\w\\e\[0m](?:\ |$)/mi).each { |n| n.slice!(0) if n[0] == " "}
    end 
end