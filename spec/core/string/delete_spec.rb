# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#delete" do |it| 
  it.returns "a new string with the chars from the intersection of sets removed" do
    s = "hello"
    s.delete("lo").should_equal("he")
    s.should_equal("hello")
    
    "hello".delete("l", "lo").should_equal("heo")
    
    "hell yeah".delete("").should_equal("hell yeah")
  end
  
  it.raises " an ArgumentError when given no arguments" do
    lambda { "hell yeah".delete }.should_raise(ArgumentError)
  end

  it.will "negate sets starting with ^" do
    "hello".delete("aeiou", "^e").should_equal("hell")
    "hello".delete("^leh").should_equal("hell")
    "hello".delete("^o").should_equal("o")
    "hello".delete("^").should_equal("hello")
    "^_^".delete("^^").should_equal("^^")
    "oa^_^o".delete("a^").should_equal("o_o")
  end

  it.will "delete all chars in a sequence" do
    "hello".delete("\x00-\xFF").should_equal("")
    "hello".delete("ej-m").should_equal("ho")
    "hello".delete("e-h").should_equal("llo")
    "hel-lo".delete("e-").should_equal("hllo")
    "hel-lo".delete("-h").should_equal("ello")
    "hel-lo".delete("---").should_equal("hello")
    "hel-012".delete("--2").should_equal("hel")
    "hel-()".delete("(--").should_equal("hel")
    "hello".delete("h-e").should_equal("hello")
    "hello".delete("^h-e").should_equal("")
    "hello".delete("^e-h").should_equal("he")
    "hello^".delete("^^-^").should_equal("^")
    "hel--lo".delete("^---").should_equal("--")

    "abcdefgh".delete("a-ce-fh").should_equal("dg")
    "abcdefgh".delete("he-fa-c").should_equal("dg")
    "abcdefgh".delete("e-fha-c").should_equal("dg")
    
    "abcde".delete("ac-e").should_equal("b")
    "abcde".delete("^ac-e").should_equal("acde")
    
    "ABCabc[]".delete("A-a").should_equal("bc")
  end
  
  it.will "taint result when self is tainted" do
    "hello".taint.delete("e").tainted?.should_equal(true)
    "hello".taint.delete("a-z").tainted?.should_equal(true)

    "hello".delete("e".taint).tainted?.should_equal(false)
  end

  it.tries "to convert each set arg to a string using to_str" do
    other_string = mock('lo')
    def other_string.to_str() "lo" end
    
    other_string2 = mock('o')
    def other_string2.to_str() "o" end
    
    "hello world".delete(other_string, other_string2).should_equal("hell wrld")

    obj = mock('x')
    obj.should_receive(:respond_to?).with(:to_str).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_str).and_return("o")
    "hello world".delete(obj).should_equal("hell wrld")
  end
  
  it.raises " a TypeError when one set arg can't be converted to a string" do
    lambda { "hello world".delete(?o)        }.should_raise(TypeError)
    lambda { "hello world".delete(:o)        }.should_raise(TypeError)
    lambda { "hello world".delete(mock('x')) }.should_raise(TypeError)
  end
  
  it.returns "subclass instances when called on a subclass" do
    StringSpecs::MyString.new("oh no!!!").delete("!").class.should_equal(StringSpecs::MyString)
  end
end

describe "String#delete!" do |it| 
  it.will "modify self in place and returns self" do
    a = "hello"
    a.delete!("aeiou", "^e").should_equal(a)
    a.should_equal("hell")
  end
  
  it.returns "nil if no modifications were made" do
    a = "hello"
    a.delete!("z").should_equal(nil)
    a.should_equal("hello")
  end
end
