# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Fixnum#<=>" do |it| 
  it.returns "-1 when self is less than the given argument" do
    (-3 <=> -1).should_equal(-1)
    (-5 <=> 10).should_equal(-1)
    (-5 <=> -4.5).should_equal(-1)
  end
  
  it.returns "0 when self is equal to the given argument" do
    (0 <=> 0).should_equal(0)
    (954 <=> 954).should_equal(0)
    (954 <=> 954.0).should_equal(0)
  end
  
  it.returns "1 when self is greater than the given argument" do
    (496 <=> 5).should_equal(1)
    (200 <=> 100).should_equal(1)
    (51 <=> 50.5).should_equal(1)
  end

  it.returns "nil when the given argument is not an Integer" do
    (3 <=> mock('x')).should_equal(nil)
    (3 <=> 'test').should_equal(nil)
  end
end
