require 'date'

# Default TextFormatter for logzomg.rb
# Allows color output to logfile

class TextFormatter
  MAX_CHAR = 150
  MAX_CHAR_FLOAT = 145.00   # There's some problems with float decimal precision. Keep this 5 below MAX_CHAR
  COLORS = {
    teal:     "96",
    orange:   "33", 
    green:    "32",
    cyan:     "36",
    blue:     "34",
    red:      "91",
    dark_red: "31"
  }

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
    c = 0
    hash.each do |key, value|
      if !key.to_s.eql?("level") && !key.to_s.eql?("msg") && !key.to_s.eql?("file")
        key = add_color_key(key, c) if @color             # Add color to keys if with_color is set to true
        str_keys_values += key.to_s + ": " + value.to_s + " | "
        c += 1
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
      str += right_align_date(n, indented, hash.size)
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
    def right_align_date(msg, indented, size)
      size = indented ? 9 : (9 * (size - 1))              # Don't count msg key as we don't colour it
      indented ? s = MAX_CHAR - 2 : s = MAX_CHAR
      " " * (s - msg.length + size)
    end

    # Adds log level to start of log
    # Add color if color is true
    def add_msg_identifier(str)
      # Need a check since debug has a different identifier than the rest
      str = @level == 'debug' ? 'DBUG' : @level[0..3].upcase
      str = add_color_level(str) if @color
      str += + " | "
    end 

    # Adds color to level if color is true
    def add_color_level(str)
      # Use this to lookup in COLORS
      colors = {debug: :blue, info: :teal, warning: :orange, error: :red, fatal: :dark_red}
      close_color = "\e[0m"
      str.prepend("\033[" + COLORS[colors[@level.to_sym]] + "m")
      str += close_color
    end

    # Adds color to hash key
    def add_color_key(key, count)
      "\033[" + COLORS[COLORS.keys[count]] + "m" + key.to_s + "\e[0m"
    end

    # Splits the message
    # This looks pretty complicated and it is but it works
    # If it substrings into the middle of a word it will go back to the last space in the substring
    # and then go from there. It uses MAX_CHAR so there's no need to change any values here if terminal size changes
    def split_msg(msg, arr)
      # This is pretty hacky but we have to add a space at the end so when we substring
      # if the string is too short and we reach the end, then we land on a space
      msg += " "
      sub_start = 0                # Where to start the substring
      sub_end = MAX_CHAR - 5       # Where to end the substring

      # How many times we need to substring
      c = msg.length > MAX_CHAR ? ((msg.length).to_f/MAX_CHAR_FLOAT).ceil : 1

      (1..c).each do |n|
        # Check to see if our substring ends in the middle of a word
        if msg[sub_start,sub_end][-1] =~ /[0-9]/ ||  msg[sub_start,sub_end][-1] =~ /[A-Za-z]/
          last_space  = msg[sub_start,sub_end].rindex(' ')           # Get index of last space in string
          s_msg       = msg[sub_start,last_space+1] + " " * (sub_end - last_space) # Add spaces to the end so right edge is still aligned
          sub_end     = last_space                                   # Make the next string start after the space
        else
          s_msg       = msg[sub_start,sub_end]                       # Substring into right length String
        end

        break if s_msg.nil? || s_msg.gsub(/[" "]/,"").length == 0    # Sometimes it likes to be nil. Break if so. Also if string is only spaces
        s_msg.slice!(0) if s_msg[0] == " "                           # Remove first char if space
        arr << s_msg
        sub_start += sub_end
      end

      arr  
    end 
end