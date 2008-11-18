# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#center with length, padding" do |it| 
  it.returns "a new string of specified length with self centered and padded with padstr" do
    "one".center(9, '.').should       == "...one..."
    "hello".center(20, '123').should  == "1231231hello12312312"
    "middle".center(13, '-').should   == "---middle----"

    "".center(1, "abcd").should_equal("a")
    "".center(2, "abcd").should_equal("aa")
    "".center(3, "abcd").should_equal("aab")
    "".center(4, "abcd").should_equal("abab")
    "".center(6, "xy").should_equal("xyxxyx")
    "".center(11, "12345").should_equal("12345123451")

    "|".center(2, "abcd").should_equal("|a")
    "|".center(3, "abcd").should_equal("a|a")
    "|".center(4, "abcd").should_equal("a|ab")
    "|".center(5, "abcd").should_equal("ab|ab")
    "|".center(6, "xy").should_equal("xy|xyx")
    "|".center(7, "xy").should_equal("xyx|xyx")
    "|".center(11, "12345").should_equal("12345|12345")
    "|".center(12, "12345").should_equal("12345|123451")

    "||".center(3, "abcd").should_equal("||a")
    "||".center(4, "abcd").should_equal("a||a")
    "||".center(5, "abcd").should_equal("a||ab")
    "||".center(6, "abcd").should_equal("ab||ab")
    "||".center(8, "xy").should_equal("xyx||xyx")
    "||".center(12, "12345").should_equal("12345||12345")
    "||".center(13, "12345").should_equal("12345||123451")
  end
  
  it.can "pads with whitespace if no padstr is given" do
    "two".center(5).should    == " two "
    "hello".center(20).should_equal("       hello        ")
  end
  
  it.returns "self if it's longer than or as long as the specified length" do
    "".center(0).should_equal("")
    "".center(-1).should_equal("")
    "hello".center(4).should_equal("hello")
    "hello".center(-1).should_equal("hello")
    "this".center(3).should_equal("this")
    "radiology".center(8, '-').should_equal("radiology")
  end

  it.can "taints result when self or padstr is tainted" do
    "x".taint.center(4).tainted?.should_equal(true)
    "x".taint.center(0).tainted?.should_equal(true)
    "".taint.center(0).tainted?.should_equal(true)
    "x".taint.center(4, "*").tainted?.should_equal(true)
    "x".center(4, "*".taint).tainted?.should_equal(true)
  end
  
  it.tries "to convert length to an integer using to_int" do
    "_".center(3.8, "^").should_equal("^_^")
    
    obj = mock('3')
    def obj.to_int() 3 end
      
    "_".center(obj, "o").should_equal("o_o")
    
    obj = mock('true')
    obj.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_int).and_return(3)
    "_".center(obj, "~").should_equal("~_~")
  end
  
  it.raises " a TypeError when length can't be converted to an integer" do
    lambda { "hello".center("x")       }.should_raise(TypeError)
    lambda { "hello".center("x", "y")  }.should_raise(TypeError)
    lambda { "hello".center([])        }.should_raise(TypeError)
    lambda { "hello".center(mock('x')) }.should_raise(TypeError)
  end
  
  it.tries "to convert padstr to a string using to_str" do
    padstr = mock('123')
    def padstr.to_str() "123" end
    
    "hello".center(20, padstr).should_equal("1231231hello12312312")

    obj = mock('x')
    obj.should_receive(:respond_to?).with(:to_str).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_str).and_return("k")

    "hello".center(7, obj).should_equal("khellok")
  end
  
  it.raises " a TypeError when padstr can't be converted to a string" do
    lambda { "hello".center(20, ?o)        }.should_raise(TypeError)
    lambda { "hello".center(20, :llo)      }.should_raise(TypeError)
    lambda { "hello".center(20, mock('x')) }.should_raise(TypeError)
  end
  
  it.raises " an ArgumentError if padstr is empty" do
    lambda { "hello".center(10, "") }.should_raise(ArgumentError)
    lambda { "hello".center(0, "")  }.should_raise(ArgumentError)
  end
  
  it.returns "subclass instances when called on subclasses" do
    StringSpecs::MyString.new("").center(10).class.should_equal(StringSpecs::MyString)
    StringSpecs::MyString.new("foo").center(10).class.should_equal(StringSpecs::MyString)
    StringSpecs::MyString.new("foo").center(10, StringSpecs::MyString.new("x")).class.should_equal(StringSpecs::MyString)
    
    "".center(10, StringSpecs::MyString.new("x")).class.should_equal(String)
    "foo".center(10, StringSpecs::MyString.new("x")).class.should_equal(String)
  end
end
