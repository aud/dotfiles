# frozen_string_literal: true

require_relative './utils'

module Brew
  class << self
    def setup
      if Utils.cmd_exists?("brew")
        puts "Skipping brew"
      else
        Utils.run_cmd('/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"')
      end
    end
  end
end

Brew.setup
