# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#<=> with String" do |it| 
  it.can "compare individual characters based on their ascii value" do
    ascii_order = Array.new(256) { |x| x.chr }
    sort_order = ascii_order.sort
    sort_order.should_equal(ascii_order)
  end
  
  it.returns "-1 when self is less than other" do
    ("this" <=> "those").should_equal(-1)
  end

  it.returns "0 when self is equal to other" do
    ("yep" <=> "yep").should_equal(0)
  end

  it.returns "1 when self is greater than other" do
    ("yoddle" <=> "griddle").should_equal(1)
  end
  
  it.can "considers string that comes lexicographically first to be less if strings have same size" do
    ("aba" <=> "abc").should_equal(-1)
    ("abc" <=> "aba").should_equal(1)
  end

  it.does_not " consider shorter string to be less if longer string starts with shorter one" do
    ("abc" <=> "abcd").should_equal(-1)
    ("abcd" <=> "abc").should_equal(1)
  end

  it.can "compare shorter string with corresponding number of first chars of longer string" do
    ("abx" <=> "abcd").should_equal(1)
    ("abcd" <=> "abx").should_equal(-1)
  end
  
  it.will "ignore subclass differences" do
    a = "hello"
    b = StringSpecs::MyString.new("hello")
    
    (a <=> b).should_equal(0)
    (b <=> a).should_equal(0)
  end
end

# Note: This is inconsistent with Array#<=> which calls to_str instead of
# just using it as an indicator.
describe "String#<=>" do |it| 
  it.returns "nil if its argument does not respond to to_str" do
    ("abc" <=> 1).should_equal(nil)
    ("abc" <=> :abc).should_equal(nil)
    ("abc" <=> mock('x')).should_equal(nil)
  end
  
  it.returns "nil if its argument does not respond to <=>" do
    obj = mock('x')
    def obj.to_str() "" end
    
    ("abc" <=> obj).should_equal(nil)
  end
  
  it.can "compare its argument and self by calling <=> on obj and turning the result around if obj responds to to_str" do
    obj = mock('x')
    def obj.to_str() "" end
    def obj.<=>(arg) 1  end
    
    ("abc" <=> obj).should_equal(-1)
    ("xyz" <=> obj).should_equal(-1)
    
    obj = mock('x')
    other = "abc"
    obj.should_receive(:respond_to?).with(:to_str).and_return(true)
    obj.should_receive(:respond_to?).with(:<=>).and_return(true)
    obj.should_receive(:method_missing).with(:<=>, other).and_return(-1)
    (other <=> obj).should_equal(+1)
  end
end
