# frozen_string_literal: true

require 'fileutils'

module Symlink
  EXCLUDED_FILES = %w(
    .
    ..
    .git
    .config
  )
  private_constant(:EXCLUDED_FILES)

  class << self
    def setup
      dotfiles = Dir.entries(".").select do |file|
        file.start_with?(".")
      end.reject do |file|
        EXCLUDED_FILES.include?(file)
      end

      dotfiles.each do |dotfile|
        from = "#{Dir.pwd}/#{dotfile}"
        to = "#{File.expand_path('~')}/#{dotfile}"

        puts "Symlinking #{from} => #{to}"
        FileUtils.ln_s(from, to, force: true)
      end
    end
  end
end

Symlink.setup
