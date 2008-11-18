# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Math.tan" do |it| 
  it.returns "a float" do
    Math.tan(1.35).class.should_equal(Float)
  end
  
  it.returns "the tangent of the argument" do
    Math.tan(0.0).should_equal(0.0)
    Math.tan(-0.0).should_equal(-0.0)
    Math.tan(4.22).should_be_close(1.86406937682395, TOLERANCE)
    Math.tan(-9.65).should_be_close(-0.229109052606441, TOLERANCE)
  end
  
  it.returns "NaN if called with +-Infinitty" do
    Math.tan(1.0/0.0).nan?.should_equal(true)
    Math.tan(1.0/-0.0).nan?.should_equal(true)
  end

  it.raises " an ArgumentError if the argument cannot be coerced with Float()" do
    lambda { Math.tan("test") }.should_raise(ArgumentError)
  end

  it.raises " a TypeError if the argument is nil" do
    lambda { Math.tan(nil) }.should_raise(TypeError)
  end    
  
  it.will "accept any argument that can be coerced with Float()" do
    Math.tan(MathSpecs::Float.new).should_be_close(1.5574077246549, TOLERANCE)
  end
end

describe "Math#tan" do |it| 
  it.is "accessible as a private instance method" do
    IncludesMath.new.send(:tan, 1.0).should_be_close(1.5574077246549, TOLERANCE)
  end
end
