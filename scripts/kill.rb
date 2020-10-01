# frozen_string_literal: true

require 'open3'

activity = false
threads = []

# Kill any matching processes
%w(
  ruby
  node
  sewing-kit
  puma
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

      threads << Thread.new do
        puts "killing process: #{initiating_command}"
        _stdout, stderr, status = Open3.capture3("kill -9 #{pid}")

        unless status.success?
          puts stderr
        end
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

      unless status.success?
        puts stderr
      end
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
