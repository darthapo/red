# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Module#private" do |it| 
  it.should "make the target method uncallable from other types" do
    obj = Object.new
    class << obj
      def foo; true; end
    end

    obj.foo.should_equal(true)

    class << obj
      private :foo
    end

    lambda { obj.foo }.should_raise(NoMethodError)
  end
end
