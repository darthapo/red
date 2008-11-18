# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#rstrip" do |it| 
  it.returns "a copy of self with trailing whitespace removed" do
   "  hello  ".rstrip.should_equal("  hello")
   "  hello world  ".rstrip.should_equal("  hello world")
   "  hello world \n\r\t\n\v\r".rstrip.should_equal("  hello world")
   "hello".rstrip.should_equal("hello")
   "hello\x00".rstrip.should_equal("hello")
  end
  
  it.will "taint the result when self is tainted" do
    "".taint.rstrip.tainted?.should_equal(true)
    "ok".taint.rstrip.tainted?.should_equal(true)
    "ok    ".taint.rstrip.tainted?.should_equal(true)
  end
end

describe "String#rstrip!" do |it| 
  it.will "modifyself in place and returns self" do
    a = "  hello  "
    a.rstrip!.should_equal(a)
    a.should_equal("  hello")
  end
  
  it.returns "nil if no modifications were made" do
    a = "hello"
    a.rstrip!.should_equal(nil)
    a.should_equal("hello")
  end
end
