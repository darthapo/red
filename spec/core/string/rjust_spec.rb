# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#rjust with length, padding" do |it| 
  it.returns "a new string of specified length with self right justified and padded with padstr" do
    "hello".rjust(20, '1234').should_equal("123412341234123hello")

    "".rjust(1, "abcd").should_equal("a")
    "".rjust(2, "abcd").should_equal("ab")
    "".rjust(3, "abcd").should_equal("abc")
    "".rjust(4, "abcd").should_equal("abcd")
    "".rjust(6, "abcd").should_equal("abcdab")

    "OK".rjust(3, "abcd").should_equal("aOK")
    "OK".rjust(4, "abcd").should_equal("abOK")
    "OK".rjust(6, "abcd").should_equal("abcdOK")
    "OK".rjust(8, "abcd").should_equal("abcdabOK")
  end
  
  it.can "pads with whitespace if no padstr is given" do
    "hello".rjust(20).should_equal("               hello")
  end

  it.returns "self if it's longer than or as long as the specified length" do
    "".rjust(0).should_equal("")
    "".rjust(-1).should_equal("")
    "hello".rjust(4).should_equal("hello")
    "hello".rjust(-1).should_equal("hello")
    "this".rjust(3).should_equal("this")
    "radiology".rjust(8, '-').should_equal("radiology")
  end

  it.will "taint result when self or padstr is tainted" do
    "x".taint.rjust(4).tainted?.should_equal(true)
    "x".taint.rjust(0).tainted?.should_equal(true)
    "".taint.rjust(0).tainted?.should_equal(true)
    "x".taint.rjust(4, "*").tainted?.should_equal(true)
    "x".rjust(4, "*".taint).tainted?.should_equal(true)
  end

  it.tries "to convert length to an integer using to_int" do
    "^".rjust(3.8, "^_").should_equal("^_^")
    
    obj = mock('3')
    def obj.to_int() 3 end
      
    "o".rjust(obj, "o_").should_equal("o_o")
    
    obj = mock('3')
    obj.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_int).and_return(3)
    "~".rjust(obj, "~_").should_equal("~_~")
  end
  
  it.raises " a TypeError when length can't be converted to an integer" do
    lambda { "hello".rjust("x")       }.should_raise(TypeError)
    lambda { "hello".rjust("x", "y")  }.should_raise(TypeError)
    lambda { "hello".rjust([])        }.should_raise(TypeError)
    lambda { "hello".rjust(mock('x')) }.should_raise(TypeError)
  end

  it.tries "to convert padstr to a string using to_str" do
    padstr = mock('123')
    def padstr.to_str() "123" end
    
    "hello".rjust(10, padstr).should_equal("12312hello")

    obj = mock('k')
    obj.should_receive(:respond_to?).with(:to_str).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_str).and_return("k")

    "hello".rjust(7, obj).should_equal("kkhello")
  end

  it.raises " a TypeError when padstr can't be converted" do
    lambda { "hello".rjust(20, :sym)      }.should_raise(TypeError)
    lambda { "hello".rjust(20, ?c)        }.should_raise(TypeError)
    lambda { "hello".rjust(20, mock('x')) }.should_raise(TypeError)
  end
  
  it.raises " an ArgumentError when padstr is empty" do
    lambda { "hello".rjust(10, '') }.should_raise(ArgumentError)
  end
  
  it.returns "subclass instances when called on subclasses" do
    StringSpecs::MyString.new("").rjust(10).class.should_equal(StringSpecs::MyString)
    StringSpecs::MyString.new("foo").rjust(10).class.should_equal(StringSpecs::MyString)
    StringSpecs::MyString.new("foo").rjust(10, StringSpecs::MyString.new("x")).class.should_equal(StringSpecs::MyString)
    
    "".rjust(10, StringSpecs::MyString.new("x")).class.should_equal(String)
    "foo".rjust(10, StringSpecs::MyString.new("x")).class.should_equal(String)
  end
end
