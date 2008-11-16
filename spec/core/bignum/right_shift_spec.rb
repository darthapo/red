# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Bignum#>>" do |it| 
  it.before(:each) do 
    @bignum = bignum_value(90812)
  end

  it.returns "self shifted the given amount of bits to the right" do
    (@bignum >> 1).should_equal(4611686018427433310)
    (@bignum >> 3).should_equal(1152921504606858327)
  end

  it.will "perform a left-shift if given a negative value" do
    (@bignum >> -1).should_equal((@bignum << 1))
    (@bignum >> -3).should_equal((@bignum << 3))
  end
  
  it.tries "to convert the given argument to an Integer using to_int" do
    (@bignum >> 1.3).should_equal(4611686018427433310)
    
    (obj = mock('1')).should_receive(:to_int).and_return(1)
    (@bignum >> obj).should_equal(4611686018427433310)
  end
  
  it.raises " a TypeError when the given argument can't be converted to Integer" do
    obj = mock('asdf')
    lambda { @bignum >> obj }.should_raise(TypeError)
    
    obj.should_receive(:to_int).and_return("asdf")
    lambda { @bignum >> obj }.should_raise(TypeError)
  end

  it.returns "0 when the given argument is a Bignum and self is positive" do
    (@bignum >> bignum_value).should_equal(0)
    
    obj = mock("Converted to Integer")
    obj.should_receive(:to_int).and_return(bignum_value)
    (@bignum >> obj).should_equal(0)
  end
  
  it.returns "-1 when the given argument is a Bignum and self is negative" do
    (-@bignum >> bignum_value).should_equal(-1)

    obj = mock("Converted to Integer")
    obj.should_receive(:to_int).and_return(bignum_value)
    (-@bignum >> obj).should_equal(-1)
  end
end