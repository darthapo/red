# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Fixnum#>>" do |it| 
  it.returns "self shifted the given amount of bits to the right" do
    (7 >> 1).should_equal(3)
    (4095 >> 3).should_equal(511)
    (9245278 >> 1).should_equal(4622639)
  end

  it.will "perform a left-shift if given a negative value" do
    (7 >> -1).should_equal((7 << 1))
    (4095 >> -3).should_equal((4095 << 3))
  end
  
  it.will "perform a right-shift if given a negative value" do
    (-7 >> 1).should_equal(-4)
    (-4095 >> 3).should_equal(-512)
  end
  
  it.tries "to convert it's argument to an Integer using to_int" do
    (7 >> 1.3).should_equal(3)
    
    (obj = mock('1')).should_receive(:to_int).and_return(1)
    (7 >> obj).should_equal(3)
  end
  
  it.raises " a TypeError when the given argument can't be converted to Integer" do
    obj = mock('asdf')
    lambda { 3 >> obj }.should_raise(TypeError)
    
    obj.should_receive(:to_int).and_return("asdf")
    lambda { 3 >> obj }.should_raise(TypeError)
  end

  it.does_not "raise RangeError when the given argument is out of range of Fixnum" do
    (obj1 = mock('large value')).should_receive(:to_int).and_return(8000_0000_0000_0000_0000)
    (obj2 = mock('large value')).should_receive(:to_int).and_return(8000_0000_0000_0000_0000)
    (3 >> obj1).should_equal(0)
    (-3 >> obj2).should_equal(-1)

    obj = 8e19
    (3 >> obj).should_equal(0)
    (-3 >> obj).should_equal(-1)
  end
end
