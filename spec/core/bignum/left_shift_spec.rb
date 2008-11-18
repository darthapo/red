# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Bignum#<<" do |it| 
  it.before(:each) do
    @bignum = bignum_value(9)
  end
  
  it.returns "self shifted the given amount of bits to the left" do
    (@bignum << 4).should_equal(147573952589676413072)
    (@bignum << 9).should_equal(4722366482869645218304)
  end

  it.will "perform a right-shift if given a negative value" do
    (@bignum << -2).should_equal((@bignum >> 2))
    (@bignum << -4).should_equal((@bignum >> 4))
  end

  it.tries "to convert the given argument to an Integer using to_int" do
    (@bignum << 4.5).should_equal(147573952589676413072)
    
    (obj = mock('4')).should_receive(:to_int).and_return(4)
    (@bignum << obj).should_equal(147573952589676413072)
  end

  it.raises " a TypeError when the given argument can't be converted to Integer" do
    obj = mock("Converted to Integer")
    lambda { @bignum << obj }.should_raise(TypeError)
    
    obj.should_receive(:to_int).and_return("asdf")
    lambda { @bignum << obj }.should_raise(TypeError)
  end

  platform_is :wordsize => 32 do
    it.raises " a RangeError when the given argument is a Bignum" do
      lambda { @bignum << bignum_value }.should_raise(RangeError)
      lambda { -@bignum << bignum_value }.should_raise(RangeError)
      
      obj = mock("Converted to Integer")
      obj.should_receive(:to_int).exactly(2).times.and_return(bignum_value)
      lambda { @bignum << obj }.should_raise(RangeError)
      lambda { -@bignum << obj }.should_raise(RangeError)
    end
  end

  platform_is :wordsize => 64 do
    it.raises " a RangeError when the given argument is a Bignum" do
      # check against 2**64 for 64-bit machines.
      lambda { @bignum << (bignum_value << 1) }.should_raise(RangeError)
      lambda { -@bignum << (bignum_value << 1) }.should_raise(RangeError)
      
      obj = mock("Converted to Integer")
      obj.should_receive(:to_int).exactly(2).times.and_return(bignum_value << 1)
      lambda { @bignum << obj }.should_raise(RangeError)
      lambda { -@bignum << obj }.should_raise(RangeError)
    end
  end
end
