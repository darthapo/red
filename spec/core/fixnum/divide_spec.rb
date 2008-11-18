# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Fixnum#/" do |it| 
  it.returns "self divided by the given argument" do
    (2 / 2).should_equal(1)
    (3 / 2).should_equal(1)
  end
  
  it.raises " a ZeroDivisionError if the given argument is zero and not a Float" do
    lambda { 1 / 0 }.should_raise(ZeroDivisionError)
  end
  
  it.does_not "raise ZeroDivisionError if the given argument is zero and is a Float" do
    (1 / 0.0).to_s.should_equal('Infinity')
    (-1 / 0.0).to_s.should_equal('-Infinity')
  end

  it.will "coerce fixnum and return self divided by other" do
    (-1 / 50.4).should_be_close(-0.0198412698412698, TOLERANCE)
    (1 / bignum_value).should_equal(0)
  end

  it.raises " a TypeError when given a non-Integer" do
    lambda {
      (obj = mock('10')).should_receive(:to_int).any_number_of_times.and_return(10)
      13 / obj
    }.should_raise(TypeError)
    lambda { 13 / "10"    }.should_raise(TypeError)
    lambda { 13 / :symbol }.should_raise(TypeError)
  end
end
