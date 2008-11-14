# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Bignum#<" do |it| 
  before(:each) do
    @bignum = bignum_value(32)
  end
  
  it.returns "true if self is less than the given argument" do
    (@bignum < @bignum + 1).should_equal(true)
    (-@bignum < -(@bignum - 1)).should_equal(true)
    
    (@bignum < 1).should_equal(false)
    (@bignum < 5).should_equal(false)
    
    (@bignum < 4.999).should_equal(false)
  end
  
  it.raises " an ArgumentError when given a non-Integer" do
    lambda { @bignum < "4" }.should_raise(ArgumentError)
    lambda { @bignum < mock('str') }.should_raise(ArgumentError)
  end
end
