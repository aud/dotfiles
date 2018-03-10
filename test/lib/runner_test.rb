require 'minitest/autorun'
require 'mocha/mini_test'
require_relative '../../lib/runner.rb'

module Dotfiles
  class RunnerTest < Minitest::Test
    def test_run!
      MockSetupRunner.expects(:instruction)
      MockSetupRunner.call
    end

    def test_add_step
      runner = Runner.new
      runner.add_step('fake instruction') {}

      assert_equal 1, runner.steps.count
    end

    class MockSetupRunner
      class << self
        def call
          runner = Runner.new
          runner.add_step('fake instruction') { instruction }
          runner.run!
        end

        def instruction
        end
      end
    end
  end
end
