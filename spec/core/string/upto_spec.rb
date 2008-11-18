# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#upto" do |it| 
  it.will "passe successive values, starting at self and ending at other_string, to the block" do
    a = []
    "*+".upto("*3") { |s| a << s }
    a.should_equal(["*+", "*,", "*-", "*.", "*/", "*0", "*1", "*2", "*3"])
  end

  it.calls " the block once even when start eqals stop" do
    a = []
    "abc".upto("abc") { |s| a << s }
    a.should_equal(["abc"])
  end

  # This is weird but MRI behaves like that
  it.will "upto calls block with self even if self is less than stop but stop length is less than self length" do
    a = []
    "25".upto("5") { |s| a << s }
    a.should_equal(["25"])
  end

  it.will "upto doesn't call block if stop is less than self and stop length is less than self length" do
    a = []
    "25".upto("1") { |s| a << s }
    a.should_equal([])
  end

  it.does_not " call the block if self is greater than stop" do
    a = []
    "5".upto("2") { |s| a << s }
    a.should_equal([])
  end

  it.will "stop iterating as soon as the current value's character count gets higher than stop's" do
    a = []
    "0".upto("A") { |s| a << s }
    a.should_equal(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"])
  end

  it.returns "self" do
    "abc".upto("abd") { }.should_equal("abc")
    "5".upto("2") { |i| i }.should_equal("5")
  end

  it.tries "to convert other to string using to_str" do
    other = mock('abd')
    def other.to_str() "abd" end

    a = []
    "abc".upto(other) { |s| a << s }
    a.should_equal(["abc", "abd"])
  end

  it.raises " a TypeError if other can't be converted to a string" do
    lambda { "abc".upto(123)       }.should_raise(TypeError)
    lambda { "abc".upto(:def) { }  }.should_raise(TypeError)
    lambda { "abc".upto(mock('x')) }.should_raise(TypeError)
  end

  it.raises " a LocalJumpError if other is a string but no block was given" do
    lambda { "abc".upto("def") }.should_raise(LocalJumpError)
  end
end
