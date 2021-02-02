# frozen_string_literal: true

require 'open3'

# def task(name)
#   puts "[start] #{name}"
#   yield
#   puts "[finish] #{name}"
# end

module Utils
  class << self
    def cmd_exists?(cmd)
      *, status = run_cmd("which #{cmd}", silent: true)
      status.success?
    end

    def darwin?
      uname, * = run_cmd("uname", silent: true)
      uname.strip == "Darwin"
    end

    def linux?
      uname, * = run_cmd("uname", silent: true)
      uname.strip == "Linux"
    end

    # Shell command out to system and output stdout, stderr
    def run_cmd(cmd, silent: false)
      puts "Running `#{cmd}`"

      Open3.popen3(cmd) do |_stdin, stdout, stderr, wait_thr|
        out, err = ""

        while line = stdout.gets
          out = line
          puts line unless silent
        end
        while line = stderr.gets
          err = line
          puts line unless silent
        end

        return out, err, wait_thr.value
      end
    end
  end
end
