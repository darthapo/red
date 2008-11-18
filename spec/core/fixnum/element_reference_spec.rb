# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Fixnum#[]" do |it| 
  it.returns "the nth bit in the binary representation of self" do
    2[3].should_equal(0)
    15[1].should_equal(1)

    2[3].should_equal(0)
    3[0xffffffff].should_equal(0)
    3[-0xffffffff].should_equal(0)
  end
  
  it.tries "to convert the given argument to an Integer using #to_int" do
    15[1.3].should_equal(15[1])
    
    (obj = mock('1')).should_receive(:to_int).and_return(1)
    2[obj].should_equal(1)
  end

  it.raises " a TypeError when the given argument can't be converted to Integer" do
    obj = mock('asdf')
    lambda { 3[obj] }.should_raise(TypeError)
    
    obj.should_receive(:to_int).and_return("asdf")
    lambda { 3[obj] }.should_raise(TypeError)
  end
end
