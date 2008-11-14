# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#downcase" do |it| 
  it.returns "a copy of self with all uppercase letters downcased" do
    "hELLO".downcase.should_equal("hello")
    "hello".downcase.should_equal("hello")
  end
  
  it.is "locale insensitive (only replaces A-Z)" do
    "ÄÖÜ".downcase.should_equal("ÄÖÜ")

    str = Array.new(256) { |c| c.chr }.join
    expected = Array.new(256) do |i|
      c = i.chr
      c.between?("A", "Z") ? c.downcase : c
    end.join
    
    str.downcase.should_equal(expected)
  end
  
  it.will "taint result when self is tainted" do
    "".taint.downcase.tainted?.should_equal(true)
    "x".taint.downcase.tainted?.should_equal(true)
    "X".taint.downcase.tainted?.should_equal(true)
  end
  
  it.returns "a subclass instance for subclasses" do
    StringSpecs::MyString.new("FOObar").downcase.class.should_equal(StringSpecs::MyString)
  end
end

describe "String#downcase!" do |it| 
  it.will "modifyself in place" do
    a = "HeLlO"
    a.downcase!.should_equal(a)
    a.should_equal("hello")
  end
  
  it.returns "nil if no modifications were made" do
    a = "hello"
    a.downcase!.should_equal(nil)
    a.should_equal("hello")
  end
end
