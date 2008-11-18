# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#chop" do |it| 
  it.returns "a new string with the last character removed" do
    "hello\n".chop.should_equal("hello")
    "hello\x00".chop.should_equal("hello")
    "hello".chop.should_equal("hell")
    
    ori_str = ""
    256.times { |i| ori_str << i }
    
    str = ori_str
    256.times do |i|
      str = str.chop
      str.should_equal(ori_str[0, 255 - i])
    end
  end
  
  it.can "remove both characters if the string ends with \\r\\n" do
    "hello\r\n".chop.should_equal("hello")
    "hello\r\n\r\n".chop.should_equal("hello\r\n")
    "hello\n\r".chop.should_equal("hello\n")
    "hello\n\n".chop.should_equal("hello\n")
    "hello\r\r".chop.should_equal("hello\r")
    
    "\r\n".chop.should_equal("")
  end
  
  it.returns "an empty string when applied to an empty string" do
    "".chop.should_equal("")
  end

  it.will "taint result when self is tainted" do
    "hello".taint.chop.tainted?.should_equal(true)
    "".taint.chop.tainted?.should_equal(true)
  end
  
  it.returns "subclass instances when called on a subclass" do
    StringSpecs::MyString.new("hello\n").chop.class.should_equal(StringSpecs::MyString)
    StringSpecs::MyString.new("hello").chop.class.should_equal(StringSpecs::MyString)
    StringSpecs::MyString.new("").chop.class.should_equal(StringSpecs::MyString)
  end
end

describe "String#chop!" do |it| 
  it.will "behave just like chop, but in-place" do
    ["hello\n", "hello\r\n", "hello", ""].each do |base|
      str = base.dup
      str.chop!
      
      str.should_equal(base.chop)
    end
  end

  it.returns "self if modifications were made" do
    ["hello", "hello\r\n"].each do |s|
      s.chop!.should_equal(s)
    end
  end

  it.returns "nil when called on an empty string" do
    "".chop!.should_equal(nil)
  end
end
