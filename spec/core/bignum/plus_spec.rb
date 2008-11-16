# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Bignum#+" do |it| 
  it.before(:each) do
    @bignum = bignum_value(76)
  end
  
  it.returns "self plus the given Integer" do
    (@bignum + 4).should_equal(9223372036854775888)
    (@bignum + 4.2).should_be_close(9223372036854775888.2, TOLERANCE)
    (@bignum + bignum_value(3)).should_equal(18446744073709551695)
  end

  it.raises " a TypeError when given a non-Integer" do
    lambda { @bignum + mock('10') }.should_raise(TypeError)
    lambda { @bignum + "10" }.should_raise(TypeError)
    lambda { @bignum + :symbol}.should_raise(TypeError)
  end
end