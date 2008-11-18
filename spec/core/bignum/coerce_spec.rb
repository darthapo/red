# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Bignum#coerce when given a Fixnum or Bignum" do |it| 
  it.returns "an Array containing the given argument and self" do
    a = bignum_value
    a.coerce(2).should_equal([2, a])
    
    b = bignum_value(701)
    a.coerce(b).should_equal([b, a])
  end
end

describe "Bignum#coerce when given a non Fixnum/Bignum" do |it| 
  it.raises " a TypeError" do
    a = bignum_value

    lambda { a.coerce(nil) }.should_raise(TypeError)
    lambda { a.coerce(mock('str')) }.should_raise(TypeError)
    lambda { a.coerce(1..4) }.should_raise(TypeError)
    lambda { a.coerce(:test) }.should_raise(TypeError)

    compliant_on :ruby, :ir do
      lambda { a.coerce(12.3) }.should_raise(TypeError)
      lambda { a.coerce("123") }.should_raise(TypeError)
    end
  end
end