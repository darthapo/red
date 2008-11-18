# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Fixnum#==" do |it| 
  it.returns "true if self has the same value as other" do
    (1 == 1).should_equal(true)
    (9 == 5).should_equal(false)
    
    # Actually, these call Float#==, Bignum#== etc.
    (9 == 9.0).should_equal(true)
    (9 == 9.01).should_equal(false)
    
    (10 == bignum_value).should_equal(false)
  end
  
  it.calls " 'other == self' if the given argument is not a Fixnum" do
    (1 == '*').should_equal(false)
    
    obj = mock('one other')
    obj.should_receive(:==).any_number_of_times.and_return(false)
    1.should_not == obj

    obj = mock('another')
    obj.should_receive(:==).any_number_of_times.and_return(true)
    2.should_equal(obj)
  end
end
