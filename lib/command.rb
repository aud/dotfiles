require 'open3'

module Dotfiles
  class Command
    class << self
      def run(cmd)
        Open3.popen3(cmd) do |_, stdout, stderr|
          while out = stdout.gets
            puts "stdout: #{out}"
          end

          while err = stderr.gets
            puts "stderr: #{err}"
          end
        end
      end
    end
  end
end
