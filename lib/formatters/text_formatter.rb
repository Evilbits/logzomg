require 'date'

# Default TextFormatter for logzomg.rb
# Allows color output to logfile

class TextFormatter

  def initialize(init_hash = Hash.new)
    @color =  init_hash.has_key?(:with_color) ? init_hash[:with_color] : true
    puts "Init color: " + @color.to_s
  end

  # Split the message into 145 char chunks. 
  # Prepend level. Append DateTime
  def format_msg(msg, level)
    @level = level
    str = ""
    s_msg = split_msg(msg)                                # Split message incase it's 150+ chars
    count = 0                                             # Use to indent on 2nd+ iteration
    
    s_msg.each do |n|
      str += add_msg_identifier(str)
      text = count >= 1 ? "  " + n : n                    # Indent if 2nd+ iteration
      str += text
      indented = count >= 1                               # Set indented to determine space amount
      str += right_align_date(n, indented)
      str += " | " + DateTime.now.to_s + "\n"
      count += 1
    end
    
    str
  end


  private
    # Adds spaces to right align date depending on str length and row number
    def right_align_date(msg, indented)
      indented ? s = 148 : s = 150
      " " * (s - msg.length)  
    end

    # Adds log level to start of log
    # Add color if color is true
    def add_msg_identifier(str)
      # Need a check since debug has a different identifier than the rest
      str += @level == 'debug' ? 'DBUG' : @level[0..3].upcase
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

    # Splits the message every 150 chars to make everything look prettier
    def split_msg(msg)
      arr = []
      start = 0
      ending = 145
      c = msg.length > 150 ? ((msg.length).to_f/150.00).ceil : 1
      (1..c).each do |n|
        arr << msg[start,ending]
        start += 146
        ending += 145
      end
      arr  
    end 
end