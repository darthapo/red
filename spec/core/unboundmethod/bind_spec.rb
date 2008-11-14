# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "UnboundMethod#bind" do |it| 
  before :each do
    @normal_um = UnboundMethodSpecs::Methods.new.method(:foo).unbind
    @parent_um = UnboundMethodSpecs::Parent.new.method(:foo).unbind
    @child1_um = UnboundMethodSpecs::Child1.new.method(:foo).unbind
    @child2_um = UnboundMethodSpecs::Child2.new.method(:foo).unbind
  end

  it.raises " TypeError if object is not kind_of? the Module the method defined in" do
    lambda { @normal_um.bind(UnboundMethodSpecs::B.new) }.should_raise(TypeError)
  end

  it.returns "Method for any object that is kind_of? the Module method was extracted from" do
    @normal_um.bind(UnboundMethodSpecs::Methods.new).class.should_equal(Method)
  end

  it.can "Method returned for obj is equal to one directly returned by obj.method" do
    obj = UnboundMethodSpecs::Methods.new
    @normal_um.bind(obj).should_equal(obj.method(:foo))
  end

  it.returns "a callable method" do
    obj = UnboundMethodSpecs::Methods.new
    @normal_um.bind(obj).call.should_equal(obj.foo)
  end
end
