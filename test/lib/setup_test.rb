require 'minitest/autorun'
require 'mocha/minitest'
require_relative '../../lib/setup.rb'

module Dotfiles
  class SetupTest < Minitest::Test
    def test_steps
      setup_instance.steps
    end

    private

    def instance
      @instance ||= Setup.new
    end
  end
end
