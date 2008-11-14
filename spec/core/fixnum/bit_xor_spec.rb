# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Fixnum#^" do |it| 
  it.returns "self bitwise EXCLUSIVE OR other" do
    (3 ^ 5).should_equal(6)
    (-2 ^ -255).should_equal(255)
    (5 ^ bignum_value + 0xffff_ffff).should_equal(0x8000_0000_ffff_fffa)
  end
  
  it.should "be able to AND a bignum with a fixnum" do
    (-1 ^ 2**64).should_equal(-18446744073709551617)
  end
    
  it.tries "to convert the given argument to an Integer using to_int" do
    (obj = mock('4')).should_receive(:to_int).and_return(4)
    (3 ^ obj).should_equal(7)
  end
  
  it.raises " a TypeError when the given argument can't be converted to Integer" do
    obj = mock('asdf')
    lambda { 3 ^ obj }.should_raise(TypeError)
    
    obj.should_receive(:to_int).and_return("asdf")
    lambda { 3 ^ obj }.should_raise(TypeError)
  end
end
