# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Math.cosh" do |it| 
  it.returns "a float" do
    Math.cosh(1.0).class.should_equal(Float)
  end
  
  it.returns "the hyperbolic cosine of the argument" do
    Math.cosh(0.0).should_equal(1.0)
    Math.cosh(-0.0).should_equal(1.0)
    Math.cosh(1.5).should_be_close(2.35240961524325, TOLERANCE)
    Math.cosh(-2.99).should_be_close(9.96798496414416, TOLERANCE)
  end

  it.raises " an ArgumentError if the argument cannot be coerced with Float()" do    
    lambda { Math.cosh("test") }.should_raise(ArgumentError)
  end
  
  it.raises " a TypeError if the argument is nil" do
    lambda { Math.cosh(nil) }.should_raise(TypeError)
  end
  
  it.will "accept any argument that can be coerced with Float()" do
    Math.cosh(MathSpecs::Float.new).should_be_close(1.54308063481524, TOLERANCE)
  end
end

describe "Math#cosh" do |it| 
  it.is "accessible as a private instance method" do
    IncludesMath.new.send(:cos, 3.1415).should_be_close(-0.999999995707656, TOLERANCE)
  end
end
