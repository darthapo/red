# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#include? with String" do |it| 
  it.returns "true if self contains other_str" do
    "hello".include?("lo").should_equal(true)
    "hello".include?("ol").should_equal(false)
  end
  
  it.will "ignore subclass differences" do
    "hello".include?(StringSpecs::MyString.new("lo")).should_equal(true)
    StringSpecs::MyString.new("hello").include?("lo").should_equal(true)
    StringSpecs::MyString.new("hello").include?(StringSpecs::MyString.new("lo")).should_equal(true)
  end
  
  it.tries "to convert other to string using to_str" do
    other = mock('lo')
    def other.to_str() "lo" end
    "hello".include?(other).should_equal(true)

    obj = mock('o')
    obj.should_receive(:respond_to?).with(:to_str).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_str).and_return("o")
    "hello".include?(obj).should_equal(true)
  end
  
  it.raises " a TypeError if other can't be converted to string" do
    lambda { "hello".include?(:lo)       }.should_raise(TypeError)
    lambda { "hello".include?(mock('x')) }.should_raise(TypeError)
  end
end

describe "String#include? with Fixnum" do |it| 
  it.returns "true if self contains the given char" do
    "hello".include?(?h).should_equal(true)
    "hello".include?(?z).should_equal(false)
    "hello".include?(0).should_equal(false)
  end
  
  it.uses "fixnum % 256" do
    "hello".include?(?h + 256 * 3).should_equal(true)
  end
  
  it.does_not " try to convert fixnum to an Integer using to_int" do
    obj = mock('x')
    obj.should_not_receive(:to_int)
    lambda { "hello".include?(obj) }.should_raise(TypeError)
  end
end
