# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Fixnum#<" do |it| 
  it.returns "true if self is less than the given argument" do
    (2 < 13).should_equal(true)
    (-600 < -500).should_equal(true)
    
    (5 < 1).should_equal(false)
    (5 < 5).should_equal(false)
    
    (900 < bignum_value).should_equal(true)
    (5 < 4.999).should_equal(false)
  end
  
  it.raises " an ArgumentError when given a non-Integer" do
    lambda { 5 < "4"       }.should_raise(ArgumentError)
    lambda { 5 < mock('x') }.should_raise(ArgumentError)
  end
end
