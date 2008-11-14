# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#ljust with length, padding" do |it| 
  it.returns "a new string of specified length with self left justified and padded with padstr" do
    "hello".ljust(20, '1234').should_equal("hello123412341234123")

    "".ljust(1, "abcd").should_equal("a")
    "".ljust(2, "abcd").should_equal("ab")
    "".ljust(3, "abcd").should_equal("abc")
    "".ljust(4, "abcd").should_equal("abcd")
    "".ljust(6, "abcd").should_equal("abcdab")

    "OK".ljust(3, "abcd").should_equal("OKa")
    "OK".ljust(4, "abcd").should_equal("OKab")
    "OK".ljust(6, "abcd").should_equal("OKabcd")
    "OK".ljust(8, "abcd").should_equal("OKabcdab")
  end
  
  it.will "pad with whitespace if no padstr is given" do
    "hello".ljust(20).should_equal("hello               ")
  end

  it.returns "self if it's longer than or as long as the specified length" do
    "".ljust(0).should_equal("")
    "".ljust(-1).should_equal("")
    "hello".ljust(4).should_equal("hello")
    "hello".ljust(-1).should_equal("hello")
    "this".ljust(3).should_equal("this")
    "radiology".ljust(8, '-').should_equal("radiology")
  end

  it.will "taint result when self or padstr is tainted" do
    "x".taint.ljust(4).tainted?.should_equal(true)
    "x".taint.ljust(0).tainted?.should_equal(true)
    "".taint.ljust(0).tainted?.should_equal(true)
    "x".taint.ljust(4, "*").tainted?.should_equal(true)
    "x".ljust(4, "*".taint).tainted?.should_equal(true)
  end

  it.tries "to convert length to an integer using to_int" do
    "^".ljust(3.8, "_^").should_equal("^_^")
    
    obj = mock('3')
    def obj.to_int() 3 end
      
    "o".ljust(obj, "_o").should_equal("o_o")
    
    obj = mock('3')
    obj.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_int).and_return(3)
    "~".ljust(obj, "_~").should_equal("~_~")
  end
  
  it.raises " a TypeError when length can't be converted to an integer" do
    lambda { "hello".ljust("x")       }.should_raise(TypeError)
    lambda { "hello".ljust("x", "y")  }.should_raise(TypeError)
    lambda { "hello".ljust([])        }.should_raise(TypeError)
    lambda { "hello".ljust(mock('x')) }.should_raise(TypeError)
  end

  it.tries "to convert padstr to a string using to_str" do
    padstr = mock('123')
    def padstr.to_str() "123" end
    
    "hello".ljust(10, padstr).should_equal("hello12312")

    obj = mock('k')
    obj.should_receive(:respond_to?).with(:to_str).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_str).and_return("k")

    "hello".ljust(7, obj).should_equal("hellokk")
  end

  it.raises " a TypeError when padstr can't be converted" do
    lambda { "hello".ljust(20, :sym)      }.should_raise(TypeError)
    lambda { "hello".ljust(20, ?c)        }.should_raise(TypeError)
    lambda { "hello".ljust(20, mock('x')) }.should_raise(TypeError)
  end
  
  it.raises " an ArgumentError when padstr is empty" do
    lambda { "hello".ljust(10, '') }.should_raise(ArgumentError)
  end
  
  it.returns "subclass instances when called on subclasses" do
    StringSpecs::MyString.new("").ljust(10).class.should_equal(StringSpecs::MyString)
    StringSpecs::MyString.new("foo").ljust(10).class.should_equal(StringSpecs::MyString)
    StringSpecs::MyString.new("foo").ljust(10, StringSpecs::MyString.new("x")).class.should_equal(StringSpecs::MyString)
    
    "".ljust(10, StringSpecs::MyString.new("x")).class.should_equal(String)
    "foo".ljust(10, StringSpecs::MyString.new("x")).class.should_equal(String)
  end
end
