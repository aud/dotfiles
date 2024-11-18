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
  puma
  sidekiq
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

      threads << Thread.new do
        puts "sigkill process: #{initiating_command}"
        _stdout, stderr, status = Open3.capture3("kill -9 #{pid}")

        puts stderr unless status.success?
      end
    end
  end
end

if activity
  threads.each(&:join)
  puts "done"
else
  puts "nothing todo"
end
