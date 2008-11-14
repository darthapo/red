# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#strip" do |it| 
  it.returns "a new string with leading and trailing whitespace removed" do
    "   hello   ".strip.should_equal("hello")
    "   hello world   ".strip.should_equal("hello world")
    "\tgoodbye\r\v\n".strip.should_equal("goodbye")
    "  goodbye \000".strip.should_equal("goodbye")
  end
  
  it.will "taint the result when self is tainted" do
    "".taint.strip.tainted?.should_equal(true)
    "ok".taint.strip.tainted?.should_equal(true)
    "  ok  ".taint.strip.tainted?.should_equal(true)
  end
end

describe "String#strip!" do |it| 
  it.will "modifyself in place and returns self" do
    a = "   hello   "
    a.strip!.should_equal(a)
    a.should_equal("hello")
  end
  
  it.returns "nil if no modifications where made" do
    a = "hello"
    a.strip!.should_equal(nil)
    a.should_equal("hello")
  end
end
