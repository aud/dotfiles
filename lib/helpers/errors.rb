class Errors
  attr_accessor :messages

  def initialize(base)
    @messages = apply_default_array({})
  end

  def add(attribute, message)
    messages[attribute.to_sym] << message
  end

  private

  def apply_default_array(hash)
    hash.default_proc = proc { |h, key| h[key] = [] }
    hash
  end
end
