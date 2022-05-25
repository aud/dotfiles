# frozen_string_literal: true

# module QuickCommands
#   UnknownSourceLocationError = Class.new(StandardError)
#   private_constant(:UnknownSourceLocationError)

#   private

#   def c; system('clear'); end
#   alias_method(:clear, :c)

#   def r; reload!; end
#   def cont; continue; end

#   def open_method(meth = nil)
#     unless meth.is_a?(Method)
#       raise ArgumentError, "Must be a reference to a method (Method)"
#     end

#     if (file, line = meth.source_location)
#       system "vim +#{line} #{file}"
#     else
#       raise UnknownSourceLocationError
#     end
#   end

#   def pbcopy(data)
#     out = data.is_a?(String) ? data : data.inspect

#     IO.popen('tr -d "\n" | pbcopy', 'w') do |io|
#       io.puts(out)
#     end
#   end
# end

# include QuickCommands

# def c; system('clear'); end
# def clear; c; end
