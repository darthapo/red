# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Math.sqrt" do |it| 
  it.returns "a float" do
    Math.sqrt(1).class.should_equal(Float)
  end
  
  it.returns "the square root of the argument" do
    Math.sqrt(1).should_equal(1.0)
    Math.sqrt(4.0).should_equal(2.0)
    Math.sqrt(15241578780673814.441547445).to_s.should_equal('123456789.123457')
  end

  it.raises " an ArgumentError if the argument cannot be coerced with Float()" do
    lambda { Math.sqrt("test") }.should_raise(ArgumentError)
  end

  it.raises " a TypeError if the argument is nil" do
    lambda { Math.sqrt(nil) }.should_raise(TypeError)
  end    
  
  it.will "accept any argument that can be coerced with Float()" do
    Math.sqrt(MathSpecs::Float.new).should_be_close(1.0, TOLERANCE)
  end
end

describe "Math#sqrt" do |it| 
  it.is "accessible as a private instance method" do
    IncludesMath.new.send(:sqrt, 2.23).should_be_close(1.49331845230681, TOLERANCE)
  end
end
