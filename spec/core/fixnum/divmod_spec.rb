# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Fixnum#divmod" do |it| 
  it.returns "an Array containing quotient and modulus obtained from dividing self by the given argument" do
    13.divmod(4).should_equal([3, 1])
    4.divmod(13).should_equal([0, 4])

    13.divmod(4.0).should_equal([3, 1])
    4.divmod(13.0).should_equal([0, 4])

    1.divmod(2.0).should_equal([0, 1.0])
    200.divmod(bignum_value).should_equal([0, 200])
  end
  
  it.raises " a ZeroDivisionError when the given argument is 0" do
    lambda { 13.divmod(0)  }.should_raise(ZeroDivisionError)
    lambda { 0.divmod(0)   }.should_raise(ZeroDivisionError)
    lambda { -10.divmod(0) }.should_raise(ZeroDivisionError)
  end

  it.raises " a FloatDomainError when the given argument is 0 and a Float" do
    lambda { 0.divmod(0.0)   }.should_raise(FloatDomainError)
    lambda { 10.divmod(0.0)  }.should_raise(FloatDomainError)
    lambda { -10.divmod(0.0) }.should_raise(FloatDomainError)
  end

  it.raises " a TypeError when given a non-Integer" do
    lambda {
      (obj = mock('10')).should_receive(:to_int).any_number_of_times.and_return(10)
      13.divmod(obj)
    }.should_raise(TypeError)
    lambda { 13.divmod("10")    }.should_raise(TypeError)
    lambda { 13.divmod(:symbol) }.should_raise(TypeError)
  end
end
