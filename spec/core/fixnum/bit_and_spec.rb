# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Fixnum#&" do |it| 
  it.returns "self bitwise AND other" do
    (256 & 16).should_equal(0)
    (2010 & 5).should_equal(0)
    (65535 & 1).should_equal(1)
    (0xffff & bignum_value + 0xffff_ffff).should_equal(65535)
  end
  
  it.should "be able to AND a bignum with a fixnum" do
    (-1 & 2**64).should_equal(18446744073709551616)
  end
  
  it.tries "to convert it's int like argument to an Integer using to_int" do
    (obj = mock('2')).should_receive(:to_int).and_return(2)
    (3 & obj).should_equal(2)
  end
  
  it.raises " a TypeError when the given argument can't be converted to Integer" do
    obj = mock('asdf')
    lambda { 3 & obj }.should_raise(TypeError)
    
    obj.should_receive(:to_int).and_return("asdf")
    lambda { 3 & obj }.should_raise(TypeError)
  end
end
