# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Fixnum#*" do |it| 
  it.returns "self multiplied by the given Integer" do
    (4923 * 2).should_equal(9846)
    (1342177 * 800).should_equal(1073741600)
    (65536 * 65536).should_equal(4294967296)

    (256 * bignum_value).should_equal(2361183241434822606848)
    (6712 * 0.25).should_equal(1678.0)
  end

  it.raises " a TypeError when given a non-Integer" do
    lambda {
      (obj = mock('10')).should_receive(:to_int).any_number_of_times.and_return(10)
      13 * obj
    }.should_raise(TypeError)
    lambda { 13 * "10"    }.should_raise(TypeError)
    lambda { 13 * :symbol }.should_raise(TypeError)
  end
end
