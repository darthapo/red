# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Bignum#-" do |it| 
  it.before(:each) do
    @bignum = bignum_value(314)
  end
  
  it.returns "self minus the given Integer" do
    (@bignum - 9).should_equal(9223372036854776113)
    (@bignum - 12.57).should_be_close(9223372036854776109.43, TOLERANCE)
    (@bignum - bignum_value(42)).should_equal(272)
  end

  it.raises " a TypeError when given a non-Integer" do
    lambda { @bignum - mock('10') }.should_raise(TypeError)
    lambda { @bignum - "10" }.should_raise(TypeError)
    lambda { @bignum - :symbol }.should_raise(TypeError)
  end
end