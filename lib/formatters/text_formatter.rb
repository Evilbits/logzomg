require 'date'

# Default TextFormatter for logzomg.rb
# Allows color output to logfile

class TextFormatter

  def initialize(init_hash = Hash.new)
    @color = init_hash.has_key?(:with_color) ? init_hash[:with_color] : true
    puts "Init color: " + @color.to_s
  end

  # Split the message into 145 char chunks. 
  # Prepend level. Append DateTime
  def format_msg(hash, level)
    @level = level                                        # Log level
    str = ""                                              # Final String we return. This is the one we add to
    str_keys_values = ""                                  # One long String in format "key: value  | key2: value2"
    s_msg = []                                            # Each index in this Array is the maximum allowed amount of chars on the screen

    # We loop over every key in the hash and format the key/value in the string format we want    
    hash.each do |key, value|
      if !key.to_s.eql?("level") && !key.to_s.eql?("msg")
        str_keys_values += key.to_s + ": " + value.to_s + "  | "
      end
    end
    str_keys_values += "msg: " + hash[:msg].to_s          # Key "msg" will always be present so do it last

    s_msg = split_msg(str_keys_values, s_msg)             # Split message incase it's 150+ chars
                
    count = 0                                             # Use to indent on 2nd+ iteration

    s_msg.each do |n|
      str += add_msg_identifier(str)
      text = count >= 1 ? "  " + n : n                    # Indent if 2nd+ iteration
      str += text
      indented = count >= 1                               # Set indented to determine space amount
      str += right_align_date(n, indented)
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
    def right_align_date(msg, indented)
      indented ? s = 148 : s = 150
      " " * (s - msg.length)
    end

    # Adds log level to start of log
    # Add color if color is true
    def add_msg_identifier(str)
      # Need a check since debug has a different identifier than the rest
      str = @level == 'debug' ? 'DBUG' : @level[0..3].upcase
      str = add_color(str) if @color
      str += + " | "
    end 

    # Adds color if color is true
    def add_color(str)
      colors = {debug: "\e[34m", info: "\e[96m", warning: "\e[33m", error: "\e[91m", fatal: "\e[31m"}
      close_color = "\e[0m"
      str.prepend(colors[@level.to_sym])
      str += close_color
    end

    # Splits the message every 145 chars to make everything look prettier
    def split_msg(msg, arr)
      start = 0
      ending = 145
      c = msg.length > 150 ? ((msg.length).to_f/145.000).ceil : 1
      (1..c).each do |n|
        s_msg = msg[start,ending]           # Substring into right length String
        s_msg.slice!(0) if s_msg[0] == " "  # Remove first char if space
        arr << s_msg
        start += 145
      end

      arr  
    end 
end