#!/usr/bin/env ruby
# frozen_string_literal: true

require "open3"
require "json"

PERSISTED_PROCESSES = [
  # Process started by dev that is always alive (self healing)
  "/usr/bin/ruby --disable-gems /opt/dev/bin/user/backend-dev",
]

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

  if processes.nil?
    next
  end

  processes.each do |process|
    activity = true

    process.split(" ").tap do |p|
      pid = p[0]
      initiating_command = p[4..].join(' ')

      next if PERSISTED_PROCESSES.include?(initiating_command)
      next if initiating_command.match?(/sshuttle/)
      next if initiating_command.match?(/isogun/)

      threads << Thread.new do
        puts "killing process: #{initiating_command}"
        _stdout, stderr, status = Open3.capture3("kill -9 #{pid}")

        puts stderr unless status.success?
      end
    end
  end
end

# Shutdown all active docker vms
stdout, stderr, status = Open3.capture3("docker ps --format '{\"id\":\"{{ .ID }}\", \"name\":\"{{ .Names }}\"}' | jq --slurp")
if status.success?
  JSON.parse(stdout).each do |vm|
    threads << Thread.new do
      id = vm.fetch("id")
      name = vm.fetch("name")

      puts "killing docker vm: #{name}"
      stdout, stderr, status = Open3.capture3("docker stop #{id}")

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
