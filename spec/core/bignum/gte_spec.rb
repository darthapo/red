# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Bignum#>=" do |it| 
  before(:each) do
    @bignum = bignum_value(14)
  end
  
  it.returns "true if self is greater than or equal to other" do
    (@bignum >= @bignum).should_equal(true)
    (@bignum >= (@bignum + 2)).should_equal(false)
    (@bignum >= 5664.2).should_equal(true)
    (@bignum >= 4).should_equal(true)
  end

  it.raises " an ArgumentError when given a non-Integer" do
    lambda { @bignum >= "4" }.should_raise(ArgumentError)
    lambda { @bignum >= mock('str') }.should_raise(ArgumentError)
  end
end
