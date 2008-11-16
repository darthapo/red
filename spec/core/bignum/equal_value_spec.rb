# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Bignum#==" do |it| 
  it.before(:each) do
    @bignum = bignum_value
  end
  
  it.returns "true if self has the same value as the given argument" do
    (@bignum == @bignum).should_equal(true)
    (@bignum == @bignum.to_f).should_equal(true)
    
    (@bignum == @bignum + 1).should_equal(false)
    (@bignum + 1 == @bignum).should_equal(false)
    
    (@bignum == 9).should_equal(false)
    (@bignum == 9.01).should_equal(false)
    
    (@bignum == bignum_value(10)).should_equal(false)
  end

  it.calls " 'other == self' if the given argument is not an Integer" do
    obj = mock('not integer')
    obj.should_receive(:==).and_return(true)
    (@bignum == obj).should_equal(true)
  end
  
  it.returns "the result of 'other == self' as a boolean" do
    obj = mock('not integer')
    obj.should_receive(:==).exactly(2).times.and_return("woot", nil)
    (@bignum == obj).should_equal(true)
    (@bignum == obj).should_equal(false)
  end
end
