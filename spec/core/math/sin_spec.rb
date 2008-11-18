# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

# sine : (-Inf, Inf) --> (-1.0, 1.0)
describe "Math.sin" do  |it| 
  it.returns "a float" do 
    Math.sin(Math::PI).class.should_equal(Float)
  end 
  
  it.returns "the sine of the argument expressed in radians" do    
    Math.sin(Math::PI).should_be_close(0.0, TOLERANCE)
    Math.sin(0).should_be_close(0.0, TOLERANCE)
    Math.sin(Math::PI/2).should_be_close(1.0, TOLERANCE)    
    Math.sin(3*Math::PI/2).should_be_close(-1.0, TOLERANCE)
    Math.sin(2*Math::PI).should_be_close(0.0, TOLERANCE)
  end  
 
  it.raises " an ArgumentError if the argument cannot be coerced with Float()" do    
    lambda { Math.sin("test") }.should_raise(ArgumentError)
  end
  
  it.raises " a TypeError if the argument is nil" do
    lambda { Math.sin(nil) }.should_raise(TypeError)
  end  
  
  it.will "accept any argument that can be coerced with Float()" do
    Math.sin(MathSpecs::Float.new).should_be_close(0.841470984807897, TOLERANCE)
  end
end

describe "Math#sin" do |it| 
  it.is "accessible as a private instance method" do
    IncludesMath.new.send(:sin, 1.21).should_be_close(0.935616001553386, TOLERANCE)
  end
end
