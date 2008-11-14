# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

# TODO: Add missing String#[]= specs:
#   String#[range] = obj
#   String#[re] = obj
#   String#[re, idx] = obj
#   String#[str] = obj

describe "String#[]= with index" do |it| 
  it.will "set the code of the character at idx to char modulo 256" do
    a = "hello"
    a[0] = ?b
    a.should_equal("bello")
    a[-1] = ?a
    a.should_equal("bella")
    a[-1] = 0
    a.should_equal("bell\x00")
    a[-5] = 0
    a.should_equal("\x00ell\x00")
    
    a = "x"
    a[0] = ?y
    a.should_equal("y")
    a[-1] = ?z
    a.should_equal("z")
    
    a[0] = 255
    a[0].should_equal(255)
    a[0] = 256
    a[0].should_equal(0)
    a[0] = 256 * 3 + 42
    a[0].should_equal(42)
    a[0] = -214
    a[0].should_equal(42)
  end
 
  it.raises " an IndexError without changing self if idx is outside of self" do
    a = "hello"
    
    lambda { a[20] = ?a }.should_raise(IndexError)
    a.should_equal("hello")
    
    lambda { a[-20] = ?a }.should_raise(IndexError)
    a.should_equal("hello")
    
    lambda { ""[0] = ?a  }.should_raise(IndexError)
    lambda { ""[-1] = ?a }.should_raise(IndexError)
  end

  it.calls " to_int on index" do
    str = "hello"
    str[0.5] = ?c
    str.should_equal("cello")
  
    obj = mock('-1')
    obj.should_receive(:to_int).and_return(-1)
    str[obj] = ?y
    str.should_equal("celly")
  
    obj = mock('-1')
    obj.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_int).and_return(-1)
    str[obj] = ?!
    str.should_equal("cell!")
  end
  
  it.will "set the code to char % 256" do
    str = "Hello"
    
    str[0] = ?a + 256 * 3
    str[0].should_equal(?a)
    str[0] = -200
    str[0].should_equal(56)
  end
  
  it.does_not " call to_int on char" do
    obj = mock('x')
    obj.should_not_receive(:to_int)
    lambda { "hi"[0] = obj }.should_raise(TypeError)
  end
end

describe "String#[]= with String" do |it| 
  it.will "replace the char at idx with other_str" do
    a = "hello"
    a[0] = "bam"
    a.should_equal("bamello")
    a[-2] = ""
    a.should_equal("bamelo")
  end

  it.will "taint self if other_str is tainted" do
    a = "hello"
    a[0] = "".taint
    a.tainted?.should_equal(true)
    
    a = "hello"
    a[0] = "x".taint
    a.tainted?.should_equal(true)
  end

  it.raises " an IndexError without changing self if idx is outside of self" do
    str = "hello"

    lambda { str[20] = "bam" }.should_raise(IndexError)
    str.should_equal("hello")
    
    lambda { str[-20] = "bam" }.should_raise(IndexError)
    str.should_equal("hello")

    lambda { ""[0] = "bam"  }.should_raise(IndexError)
    lambda { ""[-1] = "bam" }.should_raise(IndexError)
  end

  it.raises " IndexError if the string index doesn't match a position in the string" do
    str = "hello"
    lambda { str['y'] = "bam" }.should_raise(IndexError)
    str.should_equal("hello")
  end

  it.raises " IndexError if the regexp index doesn't match a position in the string" do
    str = "hello"
    lambda { str[/y/] = "bam" }.should_raise(IndexError)
    str.should_equal("hello")
  end

  it.calls " to_int on index" do
    str = "hello"
    str[0.5] = "hi "
    str.should_equal("hi ello")
  
    obj = mock('-1')
    obj.should_receive(:to_int).and_return(-1)
    str[obj] = "!"
    str.should_equal("hi ell!")
  
    obj = mock('-1')
    obj.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_int).and_return(-1)
    str[obj] = "e vator"
    str.should_equal("hi elle vator")
  end
  
  it.tries "to convert other_str to a String using to_str" do
    other_str = mock('-test-')
    def other_str.to_str() "-test-" end
    
    a = "abc"
    a[1] = other_str
    a.should_equal("a-test-c")
    
    obj = mock('ROAR')
    obj.should_receive(:respond_to?).with(:to_str).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_str).and_return("ROAR")

    a = "abc"
    a[1] = obj
    a.should_equal("aROARc")
  end
  
  it.raises " a TypeError if other_str can't be converted to a String" do
    lambda { "test"[1] = :test     }.should_raise(TypeError)
    lambda { "test"[1] = mock('x') }.should_raise(TypeError)
    lambda { "test"[1] = nil       }.should_raise(TypeError)
  end
end

describe "String#[]= with index, count" do |it| 
  it.will "start at idx and overwrites count characters before inserting the rest of other_str" do
    a = "hello"
    a[0, 2] = "xx"
    a.should_equal("xxllo")
    a = "hello"
    a[0, 2] = "jello"
    a.should_equal("jellollo")
  end
 
  it.will "count negative idx values from end of the string" do
    a = "hello"
    a[-1, 0] = "bob"
    a.should_equal("hellbobo")
    a = "hello"
    a[-5, 0] = "bob"
    a.should_equal("bobhello")
  end
 
  it.will "overwrite and deletes characters if count is more than the length of other_str" do
    a = "hello"
    a[0, 4] = "x"
    a.should_equal("xo")
    a = "hello"
    a[0, 5] = "x"
    a.should_equal("x")
  end
 
  it.will "delete characters if other_str is an empty string" do
    a = "hello"
    a[0, 2] = ""
    a.should_equal("llo")
  end
 
  it.will "delete characters up to the maximum length of the existing string" do
    a = "hello"
    a[0, 6] = "x"
    a.should_equal("x")
    a = "hello"
    a[0, 100] = ""
    a.should_equal("")
  end
 
  it.will "append other_str to the end of the string if idx == the length of the string" do
    a = "hello"
    a[5, 0] = "bob"
    a.should_equal("hellobob")
  end
  
  it.will "taint self if other_str is tainted" do
    a = "hello"
    a[0, 0] = "".taint
    a.tainted?.should_equal(true)
    
    a = "hello"
    a[1, 4] = "x".taint
    a.tainted?.should_equal(true)
  end
 
  it.raises " an IndexError if |idx| is greater than the length of the string" do
    lambda { "hello"[6, 0] = "bob"  }.should_raise(IndexError)
    lambda { "hello"[-6, 0] = "bob" }.should_raise(IndexError)
  end
 
  it.raises " an IndexError if count < 0" do
    lambda { "hello"[0, -1] = "bob" }.should_raise(IndexError)
    lambda { "hello"[1, -1] = "bob" }.should_raise(IndexError)
  end
 
  it.raises " a TypeError if other_str is a type other than String" do
    lambda { "hello"[0, 2] = nil  }.should_raise(TypeError)
    lambda { "hello"[0, 2] = :bob }.should_raise(TypeError)
    lambda { "hello"[0, 2] = 33   }.should_raise(TypeError)
  end
end
