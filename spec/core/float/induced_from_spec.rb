# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Float.induced_from" do |it| 
  it.returns "the passed argument when passed a Float" do
    Float.induced_from(5.5).should_equal(5.5)
    Float.induced_from(-5.5).should_equal(-5.5)
    Float.induced_from(TOLERANCE).should_equal(TOLERANCE)
  end
  
  it.can "convert passed Fixnums or Bignums to Floats (using #to_f)" do
    Float.induced_from(5).should_equal(5.0)
    Float.induced_from(-5).should_equal(-5.0)
    Float.induced_from(0).should_equal(0.0)
    
    Float.induced_from(bignum_value).should_equal(bignum_value.to_f)
    Float.induced_from(-bignum_value).should_equal(-bignum_value.to_f)
  end

  it.does_not "try to convert non-Integers to Integers using #to_int" do
    obj = mock("Not converted to Integer")
    obj.should_not_receive(:to_int)
    lambda { Float.induced_from(obj) }.should_raise(TypeError)
  end

  it.does_not "try to convert non-Integers to Floats using #to_f" do
    obj = mock("Not converted to Float")
    obj.should_not_receive(:to_f)
    lambda { Float.induced_from(obj) }.should_raise(TypeError)
  end
  
  it.raises " a TypeError when passed a non-Integer" do
    lambda { Float.induced_from("2") }.should_raise(TypeError)
    lambda { Float.induced_from(:symbol) }.should_raise(TypeError)
    lambda { Float.induced_from(Object.new) }.should_raise(TypeError)
  end
end 
