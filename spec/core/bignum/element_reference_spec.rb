# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Bignum#[]" do |it| 
  before(:each) do
    @bignum = bignum_value(4996)
  end
  
  it.returns "the nth bit in the binary representation of self" do
    @bignum[2].should_equal(1)
    @bignum[9.2].should_equal(1)
    @bignum[21].should_equal(0)
    @bignum[0xffffffff].should_equal(0)
    @bignum[-0xffffffff].should_equal(0)
  end

  it.tries "to convert the given argument to an Integer using #to_int" do
    @bignum[1.3].should_equal(@bignum[1])
    
    (obj = mock('2')).should_receive(:to_int).at_least(1).and_return(2)
    @bignum[obj].should_equal(1)
  end

  it.raises " a TypeError when the given argument can't be converted to Integer" do
    obj = mock('asdf')
    lambda { @bignum[obj] }.should_raise(TypeError)
    
    obj.should_receive(:to_int).and_return("asdf")
    lambda { @bignum[obj] }.should_raise(TypeError)
  end
end
