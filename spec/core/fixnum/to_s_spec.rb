# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Fixnum#to_s when given a base" do |it| 
  it.returns "self converted to a String in the given base" do
    12345.to_s(2).should_equal("11000000111001")
    12345.to_s(8).should_equal("30071")
    12345.to_s(10).should_equal("12345")
    12345.to_s(16).should_equal("3039")
    12345.to_s(36).should_equal("9ix")
  end
  
  it.raises " an ArgumentError if the base is less than 2 or higher than 36" do
    lambda { 123.to_s(-1) }.should_raise(ArgumentError)
    lambda { 123.to_s(0)  }.should_raise(ArgumentError)
    lambda { 123.to_s(1)  }.should_raise(ArgumentError)
    lambda { 123.to_s(37) }.should_raise(ArgumentError)
  end
end

describe "Fixnum#to_s when no base given" do |it| 
  it.returns "self converted to a String using base 10" do
    255.to_s.should_equal('255')
    3.to_s.should_equal('3')
    0.to_s.should_equal('0')
    -9002.to_s.should_equal('-9002')
  end
end
