#!/usr/bin/env ruby --disable-gems
# frozen_string_literal: true

threads = []

# Kill any matching processes
[
  "ruby",
  "python",
  "node",
  "puma",
  "sidekiq",
].each do |process_name|
  stdout = `pgrep -if #{process_name} | xargs ps`

  # Remove column headers
  processes = stdout.split("\n")[1..]
  next if processes.nil?

  processes.each do |process|
    p = process.split(" ")
    pid = p[0]
    initiating_command = p[4..].join(' ')

    threads << Thread.new do
      puts "sigkill process: #{initiating_command}"
      result = `kill -9 #{pid} 2>&1`
      puts result unless $?.success?
    end
  end
end

if threads.empty?
  puts "nothing todo"
else
  threads.each(&:join)
  puts "done"
end
