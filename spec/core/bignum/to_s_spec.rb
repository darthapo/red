# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Bignum#to_s when given a base" do |it| 
  it.returns "self converted to a String using the given base" do
    a = 2**64
    a.to_s(2).should_equal("10000000000000000000000000000000000000000000000000000000000000000" )
    a.to_s(8).should_equal("2000000000000000000000")
    a.to_s(16).should_equal("10000000000000000")
    a.to_s(32).should_equal("g000000000000" )
  end
  
  it.raises " an ArgumentError if the base is less than 2 or higher than 36" do
    lambda { 123.to_s(-1) }.should_raise(ArgumentError)
    lambda { 123.to_s(0) }.should_raise(ArgumentError)
    lambda { 123.to_s(1) }.should_raise(ArgumentError)
    lambda { 123.to_s(37) }.should_raise(ArgumentError)
  end
end

describe "Bignum#to_s when given no base" do |it| 
  it.returns "self converted to a String using base 10" do
    bignum_value(9).to_s.should_equal("9223372036854775817")
    bignum_value.to_s.should_equal("9223372036854775808")
    (-bignum_value(675)).to_s.should_equal("-9223372036854776483")
  end
end
