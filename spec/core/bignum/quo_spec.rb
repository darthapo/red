# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Bignum#quo" do |it| 
  before(:each) do
    @bignum = bignum_value(3)
  end

  it.returns "the result of self divided by the given Integer as a Float" do
    @bignum.quo(0xffff_afed.to_f).should_be_close(2147493897.54892, TOLERANCE)
    @bignum.quo(0xabcd_effe).should_be_close(3199892875.41007, TOLERANCE)
    @bignum.quo(bignum_value).should_be_close(1.00000000279397, TOLERANCE)
  end

  conflicts_with :Rational do
    it.does_not "raise a ZeroDivisionError when the given Integer is 0" do
      @bignum.quo(0).to_s.should_equal("Infinity")
      (-@bignum).quo(0).to_s.should_equal("-Infinity")
    end
  end

  it.does_not "raise a FloatDomainError when the given Integer is 0 and a Float" do
    @bignum.quo(0.0).to_s.should_equal("Infinity")
    (-@bignum).quo(0.0).to_s.should_equal("-Infinity")
  end

  conflicts_with :Rational do
    it.raises " a TypeError when given a non-Integer" do
      lambda {
        (obj = mock('to_int')).should_not_receive(:to_int)
        @bignum.quo(obj)
      }.should_raise(TypeError)
      lambda { @bignum.quo("10") }.should_raise(TypeError)
      lambda { @bignum.quo(:symbol) }.should_raise(TypeError)
    end
  end
end