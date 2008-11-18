# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

compliant_on :ruby, :jruby do
  describe "Module#freeze" do |it| 
    it.will "prevent further modifications to self" do
      m = Module.new.freeze
      m.frozen?.should_equal(true)
    
      # Does not raise
      class << m; end
    
      lambda {
        class << m
          def test() "test" end
        end
      }.should_raise(TypeError)

      lambda { def m.test() "test" end }.should_raise(TypeError)
    end
  end
end
