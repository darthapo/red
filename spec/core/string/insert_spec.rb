# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#insert with index, other" do |it| 
  it.will "insert other before the character at the given index" do
    "abcd".insert(0, 'X').should_equal("Xabcd")
    "abcd".insert(3, 'X').should_equal("abcXd")
    "abcd".insert(4, 'X').should_equal("abcdX")
  end
  
  it.will "modifyself in place" do
    a = "abcd"
    a.insert(4, 'X').should_equal("abcdX")
    a.should_equal("abcdX")
  end
  
  it.will "insert after the given character on an negative count" do
    "abcd".insert(-5, 'X').should_equal("Xabcd")
    "abcd".insert(-3, 'X').should_equal("abXcd")
    "abcd".insert(-1, 'X').should_equal("abcdX")
  end
  
  it.raises " an IndexError if the index is beyond string" do
    lambda { "abcd".insert(5, 'X')  }.should_raise(IndexError)
    lambda { "abcd".insert(-6, 'X') }.should_raise(IndexError)
  end
  
  it.can "convert index to an integer using to_int" do
    other = mock('-3')
    def other.to_int() -3 end
    "abcd".insert(other, "XYZ").should_equal("abXYZcd")

    obj = mock('-3')
    obj.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_int).and_return(-3)
    "abcd".insert(obj, "XYZ").should_equal("abXYZcd")
  end
  
  it.can "convert other to a string using to_str" do
    other = mock('XYZ')
    def other.to_str() "XYZ" end
    "abcd".insert(-3, other).should_equal("abXYZcd")

    obj = mock('X')
    obj.should_receive(:respond_to?).with(:to_str).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_str).and_return("X")
    "abcd".insert(-3, obj).should_equal("abXcd")
  end

  it.will "taint self if string to insert is tainted" do
    str = "abcd"
    str.insert(0, "T".taint).tainted?.should_equal(true)

    str = "abcd"
    other = mock('T')
    def other.to_str() "T".taint end
    str.insert(0, other).tainted?.should_equal(true)
  end
  
  it.raises " a TypeError if other can't be converted to string" do
    lambda { "abcd".insert(-6, ?e)        }.should_raise(TypeError)
    lambda { "abcd".insert(-6, :sym)      }.should_raise(TypeError)
    lambda { "abcd".insert(-6, mock('x')) }.should_raise(TypeError)
  end
end
