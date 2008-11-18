# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#tr_s" do |it| 
  it.returns "a string processed according to tr with newly duplicate characters removed" do
    "hello".tr_s('l', 'r').should_equal("hero")
    "hello".tr_s('el', '*').should_equal("h*o")
    "hello".tr_s('el', 'hx').should_equal("hhxo")
    "hello".tr_s('o', '.').should_equal("hell.")
  end
  
  it.will "accept c1-c2 notation to denote ranges of characters" do
    "hello".tr_s('a-y', 'b-z').should_equal("ifmp")
    "123456789".tr_s("2-5", "abcdefg").should_equal("1abcd6789")
    "hello ^--^".tr_s("e-", "__").should_equal("h_llo ^_^")
    "hello ^--^".tr_s("---", "_").should_equal("hello ^_^")
  end

  it.will "pad to_str with its last char if it is shorter than from_string" do
    "this".tr_s("this", "x").should_equal("x")
  end

  it.will "translate chars not in from_string when it starts with a ^" do
    "hello".tr_s('^aeiou', '*').should_equal("*e*o")
    "123456789".tr_s("^345", "abc").should_equal("c345c")
    "abcdefghijk".tr_s("^d-g", "9131").should_equal("1defg1")
    
    "hello ^_^".tr_s("a-e^e", ".").should_equal("h.llo ._.")
    "hello ^_^".tr_s("^^", ".").should_equal(".^.^")
    "hello ^_^".tr_s("^", "x").should_equal("hello x_x")
    "hello ^-^".tr_s("^-^", "x").should_equal("x^-^")
    "hello ^-^".tr_s("^^-^", "x").should_equal("x^x^")
    "hello ^-^".tr_s("^---", "x").should_equal("x-x")
    "hello ^-^".tr_s("^---l-o", "x").should_equal("xllox-x")
  end
  
  it.tries "to convert from_str and to_str to strings using to_str" do
    from_str = mock('ab')
    def from_str.to_str() "ab" end

    to_str = mock('AB')
    def to_str.to_str() "AB" end
    
    "bla".tr_s(from_str, to_str).should_equal("BlA")

    from_str = mock('ab')
    from_str.should_receive(:respond_to?).with(:to_str).any_number_of_times.and_return(true)
    from_str.should_receive(:method_missing).with(:to_str).and_return("ab")

    to_str = mock('AB')
    to_str.should_receive(:respond_to?).with(:to_str).any_number_of_times.and_return(true)
    to_str.should_receive(:method_missing).with(:to_str).and_return("AB")

    "bla".tr_s(from_str, to_str).should_equal("BlA")
  end
  
  it.returns "subclass instances when called on a subclass" do
    StringSpecs::MyString.new("hello").tr_s("e", "a").class.should_equal(StringSpecs::MyString)
  end
  
  it.will "taint the result when self is tainted" do
    ["h", "hello"].each do |str|
      tainted_str = str.dup.taint
      
      tainted_str.tr_s("e", "a").tainted?.should_equal(true)
      
      str.tr_s("e".taint, "a").tainted?.should_equal(false)
      str.tr_s("e", "a".taint).tainted?.should_equal(false)
    end
  end
end

describe "String#tr_s!" do |it| 
  it.will "modifyself in place" do
    s = "hello"
    s.tr_s!("l", "r").should_equal("hero")
    s.should_equal("hero")
  end
  
  it.returns "nil if no modification was made" do
    s = "hello"
    s.tr_s!("za", "yb").should_equal(nil)
    s.tr_s!("", "").should_equal(nil)
    s.should_equal("hello")
  end
  
  it.does_not "modify self if from_str is empty" do
    s = "hello"
    s.tr_s!("", "").should_equal(nil)
    s.should_equal("hello")
    s.tr_s!("", "yb").should_equal(nil)
    s.should_equal("hello")
  end
end
