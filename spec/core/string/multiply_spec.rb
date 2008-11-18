# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#*" do |it| 
  it.returns "a new string containing count copies of self" do
    ("cool" * 0).should_equal("")
    ("cool" * 1).should_equal("cool")
    ("cool" * 3).should_equal("coolcoolcool")
  end
  
  it.tries "to convert the given argument to an integer using to_int" do
    ("cool" * 3.1).should_equal("coolcoolcool")
    ("a" * 3.999).should_equal("aaa")
    
    a = mock('4')
    def a.to_int() 4; end
    ("a" * a).should_equal("aaaa")
    
    a = mock('4')
    a.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    a.should_receive(:method_missing).with(:to_int).and_return(4)
    ("a" * a).should_equal("aaaa"    )
  end
  
  it.raises " an ArgumentError when given integer is negative" do
    lambda { "cool" * -3    }.should_raise(ArgumentError)
    lambda { "cool" * -3.14 }.should_raise(ArgumentError)
  end
  
  it.raises " a RangeError when given integer is a Bignum" do
    lambda { "cool" * 999999999999999999999 }.should_raise(RangeError)
  end
  
  it.returns "subclass instances" do
    (StringSpecs::MyString.new("cool") * 0).class.should_equal(StringSpecs::MyString)
    (StringSpecs::MyString.new("cool") * 1).class.should_equal(StringSpecs::MyString)
    (StringSpecs::MyString.new("cool") * 2).class.should_equal(StringSpecs::MyString)
  end
  
  it.will "always taint the result when self is tainted" do
    ["", "OK", StringSpecs::MyString.new(""), StringSpecs::MyString.new("OK")].each do |str|
      str.taint

      [0, 1, 2].each do |arg|
        (str * arg).tainted?.should_equal(true)
      end
    end
  end
end
