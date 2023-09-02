#!/usr/bin/env ruby
# frozen_string_literal: true

require "open3"
require "json"


activity = false
threads = []

# Kill any matching processes
%w(
  ruby
  python
  node
  sewing-kit
  puma
  sidekiq
  ngrok
).each do |process_name|
  stdout, _stderr, _status = Open3.capture3("pgrep -if #{process_name} | xargs ps")

  # Remove column headers
  processes = stdout.split("\n")[1..]
  next if processes.nil?

  processes.each do |process|
    activity = true

    process.split(" ").tap do |p|
      pid = p[0]
      initiating_command = p[4..].join(' ')

      # Persistent processes
      next if initiating_command.match?(/sshuttle/)
      next if initiating_command.match?(/isogun/)
      next if initiating_command == "/usr/bin/ruby --disable-gems /opt/dev/bin/user/backend-dev"

      threads << Thread.new do
        puts "sigkill process: #{initiating_command}"
        _stdout, stderr, status = Open3.capture3("kill -9 #{pid}")

        puts stderr unless status.success?
      end
    end
  end
end

# Shutdown all active docker vms
stdout, stderr, status = Open3.capture3("podman stats --all --no-stream --no-reset --format=json")

if status.success?
  JSON.parse(stdout).each do |vm|
    threads << Thread.new do
      id = vm.fetch("id")
      name = vm.fetch("name")
      cpu_percent = vm.fetch("cpu_percent")
      mem_usage = vm.fetch("mem_usage")

      puts "killing podman vm: #{name}, cpu_perc: #{cpu_percent}, mem_usage: #{mem_usage}"
      stdout, stderr, status = Open3.capture3("podman stop #{id}")

      puts stderr unless status.success?
    end
  end
else
  puts stderr
end

if activity
  threads.each(&:join)
  puts "done"
else
  puts "nothing todo"
end
