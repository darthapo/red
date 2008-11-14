# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

# erf method is the "error function" encountered in integrating the normal 
# distribution (which is a normalized form of the Gaussian function).
describe "Math.erf" do |it| 
  it.returns "a float" do 
    Math.erf(1).class.should_equal(Float)
  end 
  
  it.returns "the error function of the argument" do 
    Math.erf(0).should_be_close(0.0, TOLERANCE)
    Math.erf(1).should_be_close(0.842700792949715, TOLERANCE)
    Math.erf(-1).should_be_close(-0.842700792949715, TOLERANCE)
    Math.erf(0.5).should_be_close(0.520499877813047, TOLERANCE)
    Math.erf(-0.5).should_be_close(-0.520499877813047, TOLERANCE)
    Math.erf(10000).should_be_close(1.0, TOLERANCE)
    Math.erf(-10000).should_be_close(-1.0, TOLERANCE)
    Math.erf(0.00000000000001).should_be_close(0.0, TOLERANCE)
    Math.erf(-0.00000000000001).should_be_close(0.0, TOLERANCE) 
  end
  
  it.raises " an ArgumentError if the argument cannot be coerced with Float()" do    
    lambda { Math.erf("test") }.should_raise(ArgumentError)
  end
  
  it.raises " a TypeError if the argument is nil" do
    lambda { Math.erf(nil) }.should_raise(TypeError)
  end 
  
  it.will "accept any argument that can be coerced with Float()" do
    Math.erf(MathSpecs::Float.new).should_be_close(0.842700792949715, TOLERANCE)
  end
end

describe "Math#erf" do |it| 
  it.is "accessible as a private instance method" do
    IncludesMath.new.send(:erf, 3.1415).should_be_close(0.999991118444483, TOLERANCE)
  end
end
