module Dotfiles
  class Runner
    attr_accessor :steps

    def initialize
      @steps = []
    end

    def add_step(name, &block)
      steps << [name, block]
    end

    def run!
      steps.each do |name, block|
        puts "Running #{name}..."
        block.call
      end
    end
  end
end
