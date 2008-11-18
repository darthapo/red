# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#chomp with separator" do |it| 
  it.returns "a new string with the given record separator removed" do
    "hello".chomp("llo").should_equal("he")
    "hellollo".chomp("llo").should_equal("hello")
  end

  it.will "remove carriage return (except \\r) chars multiple times when separator is an empty string" do
    "".chomp("").should_equal("")
    "hello".chomp("").should_equal("hello")
    "hello\n".chomp("").should_equal("hello")
    "hello\nx".chomp("").should_equal("hello\nx")
    "hello\r\n".chomp("").should_equal("hello")
    "hello\r\n\r\n\n\n\r\n".chomp("").should_equal("hello")

    "hello\r".chomp("").should_equal("hello\r")
    "hello\n\r".chomp("").should_equal("hello\n\r")
    "hello\r\r\r\n".chomp("").should_equal("hello\r\r")
  end
  
  it.will "removes carriage return chars (\\n, \\r, \\r\\n) when separator is \\n" do
    "hello".chomp("\n").should_equal("hello")
    "hello\n".chomp("\n").should_equal("hello")
    "hello\r\n".chomp("\n").should_equal("hello")
    "hello\n\r".chomp("\n").should_equal("hello\n")
    "hello\r".chomp("\n").should_equal("hello")
    "hello \n there".chomp("\n").should_equal("hello \n there")
    "hello\r\n\r\n\n\n\r\n".chomp("\n").should_equal("hello\r\n\r\n\n\n")
    
    "hello\n\r".chomp("\r").should_equal("hello\n")
    "hello\n\r\n".chomp("\r\n").should_equal("hello\n")
  end
  
  it.returns "self if the separator is nil" do
    "hello\n\n".chomp(nil).should_equal("hello\n\n")
  end
  
  it.returns "an empty string when called on an empty string" do
    "".chomp("\n").should_equal("")
    "".chomp("\r").should_equal("")
    "".chomp("").should_equal("")
    "".chomp(nil).should_equal("")
  end
  
  it.uses "$/ as the separator when none is given" do
    ["", "x", "x\n", "x\r", "x\r\n", "x\n\r\r\n", "hello"].each do |str|
      ["", "llo", "\n", "\r", nil].each do |sep|
        begin
          expected = str.chomp(sep)

          old_rec_sep, $/ = $/, sep

          str.chomp.should_equal(expected)
        ensure
          $/ = old_rec_sep
        end
      end
    end
  end
  
  it.will "taint result when self is tainted" do
    "hello".taint.chomp("llo").tainted?.should_equal(true)
    "hello".taint.chomp("").tainted?.should_equal(true)
    "hello".taint.chomp(nil).tainted?.should_equal(true)
    "hello".taint.chomp.tainted?.should_equal(true)
    "hello\n".taint.chomp.tainted?.should_equal(true)
    
    "hello".chomp("llo".taint).tainted?.should_equal(false)
  end
  
  it.tries "to convert separator to a string using to_str" do
    separator = mock('llo')
    def separator.to_str() "llo" end
    
    "hello".chomp(separator).should_equal("he")
    
    obj = mock('x')
    obj.should_receive(:respond_to?).with(:to_str).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_str).and_return("k")

    "hark".chomp(obj).should_equal("har")
  end
  
  it.raises " a TypeError if separator can't be converted to a string" do
    lambda { "hello".chomp(?o)        }.should_raise(TypeError)
    lambda { "hello".chomp(:llo)      }.should_raise(TypeError)
    lambda { "hello".chomp(mock('x')) }.should_raise(TypeError)
  end
  
  it.returns "subclass instances when called on a subclass" do
    StringSpecs::MyString.new("hello\n").chomp.class.should_equal(StringSpecs::MyString)
    StringSpecs::MyString.new("hello").chomp.class.should_equal(StringSpecs::MyString)
    StringSpecs::MyString.new("").chomp.class.should_equal(StringSpecs::MyString)
  end
end

describe "String#chomp! with seperator" do |it| 
  it.can "modify self in place and returns self" do
    s = "one\n"
    s.chomp!.should_equal(s)
    s.should_equal("one")
    
    t = "two\r\n"
    t.chomp!.should_equal(t)
    t.should_equal("two")
    
    u = "three\r"
    u.chomp!
    u.should_equal("three")
    
    v = "four\n\r"
    v.chomp!
    v.should_equal("four\n")
    
    w = "five\n\n"
    w.chomp!(nil)
    w.should_equal("five\n\n")
    
    x = "six"
    x.chomp!("ix")
    x.should_equal("s")
    
    y = "seven\n\n\n\n"
    y.chomp!("")
    y.should_equal("seven")
  end
  
  it.returns "nil if no modifications were made" do
     v = "four"
     v.chomp!.should_equal(nil)
     v.should_equal("four")
    
    "".chomp!.should_equal(nil)
    "line".chomp!.should_equal(nil)
    
    "hello\n".chomp!("x").should_equal(nil)
    "hello".chomp!("").should_equal(nil)
    "hello".chomp!(nil).should_equal(nil)
  end
end
