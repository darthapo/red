# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Fixnum#<<" do |it| 
  it.returns "self shifted the given amount of bits to the left" do
    (7 << 2).should_equal(28)
    (9 << 4).should_equal(144)
  end

  it.will "perform a right-shift if given a negative value" do
    (7 << -2).should_equal((7 >> 2))
    (9 << -4).should_equal((9 >> 4))
  end
  
  it.will "coerce result on overflow and return self shifted left other bits" do
    (9 << 4.2).should_equal(144)
    (6 << 0xff).should_equal(347376267711948586270712955026063723559809953996921692118372752023739388919808)
  end
  
  it.tries "to convert its argument to an Integer using to_int" do
    (5 << 4.3).should_equal(80)
    
    (obj = mock('4')).should_receive(:to_int).and_return(4)
    (3 << obj).should_equal(48)
  end
  
  it.raises " a TypeError when the given argument can't be converted to Integer" do
    obj = mock('asdf')
    lambda { 3 << obj }.should_raise(TypeError)
    
    obj.should_receive(:to_int).and_return("asdf")
    lambda { 3 << obj }.should_raise(TypeError)
  end

  it.raises " a RangeError when the given argument is out of range of Fixnum" do
    (obj = mock('large value')).should_receive(:to_int).and_return(8000_0000_0000_0000_0000)
    lambda { 3 << obj }.should_raise(RangeError)

    obj = 8e19
    lambda { 3 << obj }.should_raise(RangeError)
  end
end
