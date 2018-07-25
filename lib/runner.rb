require 'byebug'

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

      steps = extract_steps_from_class(block.call)

      byebug
    end

    def run!
      steps.each do |name, block|
        puts "Running #{name}..."

        # block.call(&:step_child_steps)
      end
    end

    private

    def extract_steps_from_class(klass)
      _klass = klass.const_get(:Steps).instance_methods(false)
      # ...
    end

    def foo(x, y)
      method(__method__).parameters.map do |_, name|
        binding.local_variable_get(name)
      end
    end

    attr_accessor :steps
  end
end
