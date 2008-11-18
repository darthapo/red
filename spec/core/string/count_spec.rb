# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#count" do |it| 
  it.will "count occurrences of chars from the intersection of the specified sets" do
    s = "hello\nworld\x00\x00"

    s.count(s).should_equal(s.size)
    s.count("lo").should_equal(5)
    s.count("eo").should_equal(3)
    s.count("l").should_equal(3)
    s.count("\n").should_equal(1)
    s.count("\x00").should_equal(2)
    
    s.count("").should_equal(0)
    "".count("").should_equal(0)

    s.count("l", "lo").should_equal(s.count("l"))
    s.count("l", "lo", "o").should_equal(s.count(""))
    s.count("helo", "hel", "h").should_equal(s.count("h"))
    s.count("helo", "", "x").should_equal(0)
  end

  it.raises " an ArgumentError when given no arguments" do
    lambda { "hell yeah".count }.should_raise(ArgumentError)
  end

  it.will "negate sets starting with ^" do
    s = "^hello\nworld\x00\x00"
    
    s.count("^").should_equal(1 # no negation, counts ^)

    s.count("^leh").should_equal(9)
    s.count("^o").should_equal(12)

    s.count("helo", "^el").should_equal(s.count("ho"))
    s.count("aeiou", "^e").should_equal(s.count("aiou"))
    
    "^_^".count("^^").should_equal(1)
    "oa^_^o".count("a^").should_equal(3)
  end

  it.wil "count all chars in a sequence" do
    s = "hel-[()]-lo012^"
    
    s.count("\x00-\xFF").should_equal(s.size)
    s.count("ej-m").should_equal(3)
    s.count("e-h").should_equal(2)

    # no sequences
    s.count("-").should_equal(2)
    s.count("e-").should_equal(s.count("e") + s.count("-"))
    s.count("-h").should_equal(s.count("h") + s.count("-"))

    s.count("---").should_equal(s.count("-"))
    
    # see an ASCII table for reference
    s.count("--2").should_equal(s.count("-./012"))
    s.count("(--").should_equal(s.count("()*+,-"))
    s.count("A-a").should_equal(s.count("A-Z[\\]^_`a"))
    
    # empty sequences (end before start)
    s.count("h-e").should_equal(0)
    s.count("^h-e").should_equal(s.size)

    # negated sequences
    s.count("^e-h").should_equal(s.size - s.count("e-h"))
    s.count("^^-^").should_equal(s.size - s.count("^"))
    s.count("^---").should_equal(s.size - s.count("-"))

    "abcdefgh".count("a-ce-fh").should_equal(6)
    "abcdefgh".count("he-fa-c").should_equal(6)
    "abcdefgh".count("e-fha-c").should_equal(6)

    "abcde".count("ac-e").should_equal(4)
    "abcde".count("^ac-e").should_equal(1)
  end

  it.tries "to convert each set arg to a string using to_str" do
    other_string = mock('lo')
    def other_string.to_str() "lo" end

    other_string2 = mock('o')
    def other_string2.to_str() "o" end

    s = "hello world"
    s.count(other_string, other_string2).should_equal(s.count("o"))
    
    obj = mock('k')
    obj.should_receive(:respond_to?).with(:to_str).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_str).and_return("k")
    s = "hacker kimono"
    s.count(obj).should_equal(s.count("k"))
  end
 
  it.raises " a TypeError when a set arg can't be converted to a string" do
    lambda { "hello world".count(?o)        }.should_raise(TypeError)
    lambda { "hello world".count(:o)        }.should_raise(TypeError)
    lambda { "hello world".count(mock('x')) }.should_raise(TypeError)
  end
end
