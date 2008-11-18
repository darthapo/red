# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "UnboundMethod#arity" do |it| 
  it.before(:each) do
    @um = UnboundMethodSpecs::Methods.new
  end

  it.returns "the number of arguments accepted by a method, using Method#unbind" do
    @um.method(:one).unbind.arity.should_equal(0)
    @um.method(:two).unbind.arity.should_equal(1)
    @um.method(:three).unbind.arity.should_equal(2)
    @um.method(:four).unbind.arity.should_equal(2)
  end

  it.returns "the number arguments accepted by a method, using Module#instance_method" do
    UnboundMethodSpecs::Methods.instance_method(:one).arity.should_equal(0)
    UnboundMethodSpecs::Methods.instance_method(:two).arity.should_equal(1)
    UnboundMethodSpecs::Methods.instance_method(:three).arity.should_equal(2)
    UnboundMethodSpecs::Methods.instance_method(:four).arity.should_equal(2)
  end

  it.will "if optional arguments returns the negative number of mandatory arguments, using Method#unbind" do
    @um.method(:neg_one).unbind.arity.should_equal(-1)
    @um.method(:neg_two).unbind.arity.should_equal(-2)
    @um.method(:neg_three).unbind.arity.should_equal(-3)
    @um.method(:neg_four).unbind.arity.should_equal(-3)
  end

  it.will "if optional arguments returns the negative number of mandatory arguments, using Module#instance_method" do
    UnboundMethodSpecs::Methods.instance_method(:neg_one).arity.should_equal(-1)
    UnboundMethodSpecs::Methods.instance_method(:neg_two).arity.should_equal(-2)
    UnboundMethodSpecs::Methods.instance_method(:neg_three).arity.should_equal(-3)
    UnboundMethodSpecs::Methods.instance_method(:neg_four).arity.should_equal(-3)
  end
end
