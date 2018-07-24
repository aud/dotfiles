require_relative 'runner'
require_relative 'command'
require_relative 'helpers/errors'

Dir["#{File.dirname(__FILE__)}/**/*.rb"].each { |f| require_relative f }

module Dotfiles
  class Setup
    attr_accessor :errors

    ROOT_LIB_PATH = File.expand_path('../../', __FILE__)
    HOME_PATH = Dir.home

    def initialize
      @errors = Errors.new(self)
    end

    def steps
      runner = Runner.new

      runner.add_step_child('build symlinks') { Symlinks }

      runner.run!
    end
  end
end
