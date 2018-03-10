require 'minitest/autorun'
require_relative '../../lib/helpers/errors.rb'

module Dotfiles
  class ErrorsTest < Minitest::Test
    def test_add
      errors_instance.add(:base, 'fail')
      assert errors_instance.messages.any?
    end

    private

    def errors_instance
      @errors ||= Errors.new(self)
    end
  end
end
