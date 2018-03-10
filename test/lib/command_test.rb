require 'minitest/autorun'
require 'mocha/mini_test'
require_relative '../../lib/command.rb'

module Dotfiles
  class CommandTest < Minitest::Test
    def test_run_stdoutu
      STDOUT.expects(:puts).with("stdout: tests\n")
      Command.run('echo tests')
    end
  end
end
