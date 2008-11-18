# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Integer.induced_from with [Float]" do |it| 
  it.returns "a Fixnum when the passed Float is in Fixnum's range" do
    Integer.induced_from(2.5).should_equal(2)
    Integer.induced_from(-3.14).should_equal(-3)
    Integer.induced_from(10 - TOLERANCE).should_equal(9)
    Integer.induced_from(TOLERANCE).should_equal(0)
  end
  
  it.returns "a Bignum when the passed Float is out of Fixnum's range" do
    Integer.induced_from(bignum_value.to_f).should_equal(bignum_value)
    Integer.induced_from(-bignum_value.to_f).should_equal(-bignum_value)
  end
end

describe "Integer.induced_from" do |it| 
  it.returns "the passed argument when passed a Bignum or Fixnum" do
    Integer.induced_from(1).should_equal(1)
    Integer.induced_from(-10).should_equal(-10)
    Integer.induced_from(bignum_value).should_equal(bignum_value)
  end
  
  it.does_not "try to convert non-Integers to Integers using #to_int" do
    obj = mock("Not converted to Integer")
    obj.should_not_receive(:to_int)
    lambda { Integer.induced_from(obj) }.should_raise(TypeError)
  end

  it.does_not "try to convert non-Integers to Integers using #to_i" do
    obj = mock("Not converted to Integer")
    obj.should_not_receive(:to_i)
    lambda { Integer.induced_from(obj) }.should_raise(TypeError)
  end
  
  it.raises " a TypeError when passed a non-Integer" do
    lambda { Integer.induced_from("2") }.should_raise(TypeError)
    lambda { Integer.induced_from(:symbol) }.should_raise(TypeError)
    lambda { Integer.induced_from(Object.new) }.should_raise(TypeError)
  end
end
