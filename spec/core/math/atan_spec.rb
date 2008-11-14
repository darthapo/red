# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

# arctangent : (-Inf, Inf) --> (-PI/2, PI/2)
describe "Math.atan" do      |it| 
  it.returns "a float" do 
    Math.atan(1).class.should_equal(Float)
  end 
  
  it.returns " the arctangent of the argument" do    
    Math.atan(1).should_be_close(Math::PI/4, TOLERANCE)
    Math.atan(0).should_be_close(0.0, TOLERANCE)
    Math.atan(-1).should_be_close(-Math::PI/4, TOLERANCE)
    Math.atan(0.25).should_be_close(0.244978663126864, TOLERANCE)
    Math.atan(0.50).should_be_close(0.463647609000806, TOLERANCE)
    Math.atan(0.75).should_be_close(0.643501108793284, TOLERANCE)
  end   
  
  it.raises " an ArgumentError if the argument cannot be coerced with Float()" do    
    lambda { Math.atan("test") }.should_raise(ArgumentError)
  end
  
  it.raises " a TypeError if the argument is nil" do
    lambda { Math.atan(nil) }.should_raise(TypeError)
  end  
  
  it.will "accept any argument that can be coerced with Float()" do
    Math.atan(MathSpecs::Float.new).should_be_close(0.785398163397448, TOLERANCE)
  end
end

describe "Math#atan" do |it| 
  it.is "accessible as a private instance method" do
    IncludesMath.new.send(:atan, 3.1415).should_be_close(1.2626187313511, TOLERANCE)
  end
end
