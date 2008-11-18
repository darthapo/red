# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

# arccosine : (-1.0, 1.0) --> (0, PI)	 	                
describe "Math.acos" do   |it| 
  it.returns "a float" do 
    Math.acos(1).class.should_equal(Float )
  end 
  
  it.returns "the arccosine of the argument" do 
    Math.acos(1).should_be_close(0.0, TOLERANCE) 
    Math.acos(0).should_be_close(1.5707963267949, TOLERANCE) 
    Math.acos(-1).should_be_close(Math::PI,TOLERANCE) 
    Math.acos(0.25).should_be_close(1.31811607165282, TOLERANCE) 
    Math.acos(0.50).should_be_close(1.0471975511966 , TOLERANCE) 
    Math.acos(0.75).should_be_close(0.722734247813416, TOLERANCE) 
  end  
  
  it.raises "an ArgumentError if the argument cannot be coerced with Float()" do    
    lambda { Math.acos("test") }.should_raise(ArgumentError)
  end
  
  it.raises "a TypeError if the argument is nil" do
    lambda { Math.acos(nil) }.should_raise(TypeError)
  end  

  it.will "accept any argument that can be coerced with Float()" do
    Math.acos(MathSpecs::Float.new).should_equal(0.0)
  end
end

describe "Math#acos" do |it| 
  it.is "accessible as a private instance method" do
    IncludesMath.new.send(:acos, 0).should_be_close(1.5707963267949, TOLERANCE)
  end
end
