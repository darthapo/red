# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#capitalize" do |it| 
  it.returns "a copy of self with the first character converted to uppercase and the remainder to lowercase" do
    "".capitalize.should_equal("")
    "h".capitalize.should_equal("H")
    "H".capitalize.should_equal("H")
    "hello".capitalize.should_equal("Hello")
    "HELLO".capitalize.should_equal("Hello")
    "123ABC".capitalize.should_equal("123abc")
  end

  it.will "taint resulting string when self is tainted" do
    "".taint.capitalize.tainted?.should_equal(true)
    "hello".taint.capitalize.tainted?.should_equal(true)
  end

  it.is "locale insensitive (only upcases a-z and only downcases A-Z)" do
    "ÄÖÜ".capitalize.should_equal("ÄÖÜ")
    "ärger".capitalize.should_equal("ärger")
    "BÄR".capitalize.should_equal("BÄr")
  end
  
  it.returns "subclass instances when called on a subclass" do
    StringSpecs::MyString.new("hello").capitalize.class.should_equal(StringSpecs::MyString)
    StringSpecs::MyString.new("Hello").capitalize.class.should_equal(StringSpecs::MyString)
  end
end

describe "String#capitalize!" do |it| 
  it.can "capitalize self in place" do
    a = "hello"
    a.capitalize!.should_equal(a)
    a.should_equal("Hello")
  end
  
  it.returns "nil when no changes are made" do
    a = "Hello"
    a.capitalize!.should_equal(nil)
    a.should_equal("Hello")
    
    "".capitalize!.should_equal(nil)
    "H".capitalize!.should_equal(nil)
  end
end
