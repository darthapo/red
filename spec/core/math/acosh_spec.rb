# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Math.acosh" do |it| 
  it.returns "a float" do
    Math.acosh(1.0).class.should_equal(Float)
  end
  
  it.returns "the principle value of the inverse hyperbolic cosine of the argument" do
    Math.acosh(14.2).should_be_close(3.345146999647, TOLERANCE)
    Math.acosh(1.0).should_be_close(0.0, TOLERANCE)
  end
  
  it.raises " an ArgumentError if the argument cannot be coerced with Float()" do
    lambda { Math.acosh("test") }.should_raise(ArgumentError)
  end

  it.raises " a TypeError if the argument is nil" do
    lambda { Math.acosh(nil) }.should_raise(TypeError)
  end  

  it.will "accept any argument that can be coerced with Float()" do
    Math.acosh(MathSpecs::Float.new).should_equal(0.0)
  end
end

describe "Math#acosh" do |it| 
  it.is "accessible as a private instance method" do
    IncludesMath.new.send(:acosh, 1.0).should_be_close(0.0, TOLERANCE)
  end
end
