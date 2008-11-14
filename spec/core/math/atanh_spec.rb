# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Math.atanh" do |it| 
  it.returns "a float" do
    Math.atanh(0.5).class.should_equal(Float)
  end
  
  it.returns "the inverse hyperbolic tangent of the argument" do
    Math.atanh(0.0).should_equal(0.0)
    Math.atanh(-0.0).should_equal(-0.0)
    Math.atanh(0.5).should_be_close(0.549306144334055, TOLERANCE)
    Math.atanh(-0.2).should_be_close(-0.202732554054082, TOLERANCE)
  end
    
  it.raises " an ArgumentError if the argument cannot be coerced with Float()" do
    lambda { Math.atanh("test") }.should_raise(ArgumentError)
  end

  it.raises " a TypeError if the argument is nil" do
    lambda { Math.atanh(nil) }.should_raise(TypeError)
  end
  
  it.will "accept any argument that can be coerced with Float()" do
    Math.atanh(MathSpecs::Float.new(0.5)).infinite?.should_equal(nil)
  end
end

describe "Math#atanh" do |it| 
  it.is "accessible as a private instance method" do
    IncludesMath.new.send(:atanh, 0.1415).should_be_close(0.14245589281616, TOLERANCE)
  end
end
