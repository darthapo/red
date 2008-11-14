# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#upcase" do |it| 
  it.returns "a copy of self with all lowercase letters upcased" do
    "Hello".upcase.should_equal("HELLO")
    "hello".upcase.should_equal("HELLO")
  end
  
  it.is "locale insensitive (only replaces a-z)" do
    "äöü".upcase.should_equal("äöü")

    str = Array.new(256) { |c| c.chr }.join
    expected = Array.new(256) do |i|
      c = i.chr
      c.between?("a", "z") ? c.upcase : c
    end.join
    
    str.upcase.should_equal(expected)
  end
  
  it.will "taint result when self is tainted" do
    "".taint.upcase.tainted?.should_equal(true)
    "X".taint.upcase.tainted?.should_equal(true)
    "x".taint.upcase.tainted?.should_equal(true)
  end
  
  it.returns "a subclass instance for subclasses" do
    StringSpecs::MyString.new("fooBAR").upcase.class.should_equal(StringSpecs::MyString)
  end
end

describe "String#upcase!" do |it| 
  it.will "modifyself in place" do
    a = "HeLlO"
    a.upcase!.should_equal(a)
    a.should_equal("HELLO")
  end
  
  it.returns "nil if no modifications were made" do
    a = "HELLO"
    a.upcase!.should_equal(nil)
    a.should_equal("HELLO")
  end
end
