#!/usr/bin/env ruby --disable-gems

PATTERNS = [
  /ruby/,
  /python/,
  /node/,
  /puma/,
  /sidekiq/,
  /celery/,
  /caddy/,
  /claude/,
  /\bbun\b/
]
PAGE_DIR = File.expand_path("~/src/github.com/WithPage/page")
SOCK_GLOB = "#{PAGE_DIR}/.overmind-*"
PORT_FILE = "#{PAGE_DIR}/.port"
MY_PID = Process.pid

def run(cmd)
  warn "+ #{cmd}"
  out = `#{cmd} 2>&1`
  warn out unless out.empty?
  warn "+ exit #{$?.exitstatus}" unless $?.success?
  out
end

count = 0
PATTERNS.each do |pattern|
  pids = `pgrep -if #{pattern.source.inspect}`.split.map(&:to_i)
  pids.reject! { |pid| pid == MY_PID }
  next if pids.empty?

  ps_out = `ps -o pid=,command= -p #{pids.join(',')} 2>/dev/null`
  ps_out.each_line do |line|
    pid, cmd = line.strip.split(" ", 2)
    warn "+ kill -9 #{pid} # #{cmd}"
    begin
      Process.kill(:KILL, pid.to_i)
    rescue Errno::ESRCH
    end

    count += 1
  end
end

socks = Dir.glob(SOCK_GLOB)
run("rm -f #{SOCK_GLOB}") unless socks.empty?
run("rm -f #{PORT_FILE}") if File.exist?(PORT_FILE)

puts count > 0 ? "done (#{count})" : "nothing todo"
