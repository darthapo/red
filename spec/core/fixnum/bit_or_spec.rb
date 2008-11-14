# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Fixnum#|" do |it| 
  it.returns "self bitwise OR other" do
    (1 | 0).should_equal(1)
    (5 | 4).should_equal(5)
    (5 | 6).should_equal(7)
    (248 | 4096).should_equal(4344)
    (0xffff | bignum_value + 0xf0f0).should_equal(0x8000_0000_0000_ffff)
  end

  it.should "be able to AND a bignum with a fixnum" do
    (-1 | 2**64).should_equal(-1)
  end
    
  it.tries "to convert the int like argument to an Integer using to_int" do
    (obj = mock('4')).should_receive(:to_int).and_return(4)
    (3 | obj).should_equal(7)
  end
  
  it.raises " a TypeError when the given argument can't be converted to Integer" do
    obj = mock('asdf')
    lambda { 3 | obj }.should_raise(TypeError)
    
    obj.should_receive(:to_int).and_return("asdf")
    lambda { 3 | obj }.should_raise(TypeError)
  end
end
