# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#replace" do |it| 
  it.will "replace the content of self with other and returns self" do
    a = "some string"
    a.replace("another string").should_equal(a)
    a.should_equal("another string")
  end
  
  it.will "replace the taint status of self with that of other" do
    a = "an untainted string"
    b = "a tainted string".taint
    a.replace(b)
    a.tainted?.should_equal(true)
  end
  
  it.tries "to convert other to string using to_str" do
    other = mock('x')
    def other.to_str() "an object converted to a string" end
    "hello".replace(other).should_equal("an object converted to a string")

    obj = mock('X')
    obj.should_receive(:respond_to?).with(:to_str).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_str).and_return("X")
    "hello".replace(obj).should_equal("X")
  end
  
  it.raises " a TypeError if other can't be converted to string" do
    lambda { "hello".replace(123)       }.should_raise(TypeError)
    lambda { "hello".replace(:test)     }.should_raise(TypeError)
    lambda { "hello".replace(mock('x')) }.should_raise(TypeError)
  end
end
