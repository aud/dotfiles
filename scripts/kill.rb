#!/usr/bin/env ruby
# frozen_string_literal: true

require 'open3'

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

    process.split(' ').tap do |p|
      pid = p[0]
      initiating_command = p[4..].join(' ')

      next if PERSISTED_PROCESSES.include?(initiating_command)

      threads << Thread.new do
        puts "killing process: #{initiating_command}"
        _stdout, stderr, status = Open3.capture3("kill -9 #{pid}")

        puts stderr unless status.success?
      end
    end
  end
end

# Shutdown active Railgun vms
stdout, stderr, status = Open3.capture3('railgun status -a -H -o name')

if status.success?
  running_vms = stdout.split("\n")
  running_vms.each do |vm|
    activity = true

    threads << Thread.new do
      puts "killing railgun vm: #{vm}"
      stdout, stderr, status = Open3.capture3("railgun stop #{vm}")

      puts stderr unless status.success?
    end
  end
else
  puts stderr
end

if activity
  threads.each(&:join)
  puts 'done'
else
  puts 'nothing todo'
end
