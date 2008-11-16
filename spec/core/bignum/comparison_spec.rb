# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Bignum#<=>" do |it| 
  it.before(:each) do
    @bignum = bignum_value(96)
  end
  
  it.returns "-1 when self is less than the given argument" do
    (-@bignum <=> @bignum).should_equal(-1)
    (-@bignum <=> -1).should_equal(-1)
    (-@bignum <=> -4.5).should_equal(-1)
  end
  
  it.returns "0 when self is equal to the given argument" do
    (@bignum <=> @bignum).should_equal(0)
    (-@bignum <=> -@bignum).should_equal(0)
  end
  
  it.returns "1 when self is greater than the given argument" do
    (@bignum <=> -@bignum).should_equal(1)
    (@bignum <=> 1).should_equal(1)
    (@bignum <=> 4.5).should_equal(1)
  end

  it.returns "nil when the given argument is not an Integer" do
    (@bignum <=> mock('str')).should_equal(nil)
    (@bignum <=> 'test').should_equal(nil)
  end
end
