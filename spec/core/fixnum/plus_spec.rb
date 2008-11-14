# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Fixnum#+" do |it| 
  it.returns "self plus the given Integer" do
    (491 + 2).should_equal(493)
    (90210 + 10).should_equal(90220)

    (9 + bignum_value).should_equal(9223372036854775817)
    (1001 + 5.219).should_equal(1006.219)
  end

  it.raises " a TypeError when given a non-Integer" do
    lambda {
      (obj = mock('10')).should_receive(:to_int).any_number_of_times.and_return(10)
      13 + obj
    }.should_raise(TypeError)
    lambda { 13 + "10"    }.should_raise(TypeError)
    lambda { 13 + :symbol }.should_raise(TypeError)
  end
end
