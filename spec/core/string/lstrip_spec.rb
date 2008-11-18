# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#lstrip" do |it| 
  it.returns "a copy of self with leading whitespace removed" do
   "  hello  ".lstrip.should_equal("hello  ")
   "  hello world  ".lstrip.should_equal("hello world  ")
   "\n\r\t\n\v\r hello world  ".lstrip.should_equal("hello world  ")
   "hello".lstrip.should_equal("hello")
  end
  
  it.will "taint the result when self is tainted" do
    "".taint.lstrip.tainted?.should_equal(true)
    "ok".taint.lstrip.tainted?.should_equal(true)
    "   ok".taint.lstrip.tainted?.should_equal(true)
  end
end

describe "String#lstrip!" do |it| 
  it.will "modifyself in place and returns self" do
    a = "  hello  "
    a.lstrip!.should_equal(a)
    a.should_equal("hello  ")
  end
  
  it.returns "nil if no modifications were made" do
    a = "hello"
    a.lstrip!.should_equal(nil)
    a.should_equal("hello")
  end
end
