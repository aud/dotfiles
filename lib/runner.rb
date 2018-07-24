module Dotfiles
  class Runner
    MissingBlockError = Class.new(StandardError)

    def initialize
      @steps = []
    end

    def add_step(name, &block)
      raise MissingBlockError unless block_given?
      steps << [name, block]
    end

    def add_step_child(name, &block)
      raise MissingBlockError unless block_given?

      require 'byebug'

      byebug
      block.call(&:step_child_steps)
    end

    def run!
      steps.each do |name, block|
        puts "Running #{name}..."

        # block.call(&:step_child_steps)
      end
    end

    private

    def step_child_steps
      yield.tap do |klass|
        # Get methods
        klass.const_get(:Steps).instance_methods(false)

        # Get `msg` from method arguments, raise with message if doesn't exist.
        # Append to steps.
      end
    end

    attr_accessor :steps
  end
end
