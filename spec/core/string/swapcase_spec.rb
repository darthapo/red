# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#swapcase" do |it| 
  it.returns "a new string with all uppercase chars from self converted to lowercase and vice versa" do
   "Hello".swapcase.should_equal("hELLO")
   "cYbEr_PuNk11".swapcase.should_equal("CyBeR_pUnK11")
   "+++---111222???".swapcase.should_equal("+++---111222???")
  end
  
  it.will "taint resulting string when self is tainted" do
    "".taint.swapcase.tainted?.should_equal(true)
    "hello".taint.swapcase.tainted?.should_equal(true)
  end

  it.is "locale insensitive (only upcases a-z and only downcases A-Z)" do
    "ÄÖÜ".swapcase.should_equal("ÄÖÜ")
    "ärger".swapcase.should_equal("äRGER")
    "BÄR".swapcase.should_equal("bÄr")
  end
  
  it.returns "subclass instances when called on a subclass" do
    StringSpecs::MyString.new("").swapcase.class.should_equal(StringSpecs::MyString)
    StringSpecs::MyString.new("hello").swapcase.class.should_equal(StringSpecs::MyString)
  end
end

describe "String#swapcase!" do |it| 
  it.will "modifyself in place" do
    a = "cYbEr_PuNk11"
    a.swapcase!.should_equal(a)
    a.should_equal("CyBeR_pUnK11")
  end
  
  it.returns "nil if no modifications were made" do
    a = "+++---111222???"
    a.swapcase!.should_equal(nil)
    a.should_equal("+++---111222???")
    
    "".swapcase!.should_equal(nil)
  end
end
