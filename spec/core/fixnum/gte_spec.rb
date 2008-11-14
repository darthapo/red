# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Fixnum#>=" do |it| 
  it.returns "true if self is greater than or equal to the given argument" do
    (13 >= 2).should_equal(true)
    (-500 >= -600).should_equal(true)
    
    (1 >= 5).should_equal(false)
    (2 >= 2).should_equal(true)
    (5 >= 5).should_equal(true)
    
    (900 >= bignum_value).should_equal(false)
    (5 >= 4.999).should_equal(true)
  end

  it.raises " an ArgumentError when given a non-Integer" do
    lambda { 5 >= "4"       }.should_raise(ArgumentError)
    lambda { 5 >= mock('x') }.should_raise(ArgumentError)
  end
end
