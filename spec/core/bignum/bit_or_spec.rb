# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Bignum#|" do |it| 
  it.before(:each) do
    @bignum = bignum_value(11) 
  end
  
  it.returns "self bitwise OR other" do
    (@bignum | 2).should_equal(9223372036854775819)
    (@bignum | 9).should_equal(9223372036854775819)
    (@bignum | bignum_value).should_equal(9223372036854775819)
    (bignum_value | bignum_value(0xffff).to_f).should_equal(9223372036854841344)
  end

  it.tries "to convert the given argument to an Integer using to_int" do
    (@bignum | 9.9).should_equal(9223372036854775819)
    
    (obj = mock('2')).should_receive(:to_int).and_return(2)
    (@bignum | obj).should_equal(9223372036854775819)
  end
  
  it.raises " a TypeError when the given argument can't be converted to Integer" do
    obj = mock('asdf')
    lambda { @bignum | obj }.should_raise(TypeError)
    
    obj.should_receive(:to_int).and_return("asdf")
    lambda { @bignum | obj }.should_raise(TypeError)
  end
end
