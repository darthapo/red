# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Fixnum#-" do |it| 
  it.returns "self minus the given Integer" do
    (5 - 10).should_equal(-5)
    (9237212 - 5_280).should_equal(9231932)
    
    (781 - 0.5).should_equal(780.5)
    (2_560_496 - bignum_value).should_equal(-9223372036852215312)
  end
  
  it.raises " a TypeError when given a non-Integer" do
    lambda {
      (obj = mock('10')).should_receive(:to_int).any_number_of_times.and_return(10)
      13 - obj
    }.should_raise(TypeError)
    lambda { 13 - "10"    }.should_raise(TypeError)
    lambda { 13 - :symbol }.should_raise(TypeError)
  end
end
