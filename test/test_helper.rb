require "test/unit"
require "mocha/setup"
require "turn"

Test::Unit::TestCase.class_eval do
  def self.test(name, &block)
    define_method("test_#{name.to_s.gsub(/\W/,'_')}", &block) if block_given?
  end
end