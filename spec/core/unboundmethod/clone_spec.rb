# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "UnboundMethod#clone" do |it| 
  it.returns "a copy of the UnboundMethod" do
    um1 = UnboundMethodSpecs::Methods.instance_method(:foo)
    um2 = um1.clone

    (um1 == um2).should_equal(true)
    um1.bind(UnboundMethodSpecs::Methods.new).call.should_equal(um2.bind(UnboundMethodSpecs::Methods.new).call)
  end
end
