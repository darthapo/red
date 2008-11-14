# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#tr" do |it| 
  it.returns "a new string with the characters from from_string replaced by the ones in to_string" do
    "hello".tr('aeiou', '*').should_equal("h*ll*")
    "hello".tr('el', 'ip').should_equal("hippo")
    "Lisp".tr("Lisp", "Ruby").should_equal("Ruby")
  end
  
  it.will "accept c1-c2 notation to denote ranges of characters" do
    "hello".tr('a-y', 'b-z').should_equal("ifmmp")
    "123456789".tr("2-5","abcdefg").should_equal("1abcd6789")
    "hello ^-^".tr("e-", "__").should_equal("h_llo ^_^")
    "hello ^-^".tr("---", "_").should_equal("hello ^_^")
  end
  
  it.will "pad to_str with its last char if it is shorter than from_string" do
    "this".tr("this", "x").should_equal("xxxx")
    "hello".tr("a-z", "A-H.").should_equal("HE...")
  end
  
  it.will "translate chars not in from_string when it starts with a ^" do
    "hello".tr('^aeiou', '*').should_equal("*e**o")
    "123456789".tr("^345", "abc").should_equal("cc345cccc")
    "abcdefghijk".tr("^d-g", "9131").should_equal("111defg1111")
    
    "hello ^_^".tr("a-e^e", ".").should_equal("h.llo ._.")
    "hello ^_^".tr("^^", ".").should_equal("......^.^")
    "hello ^_^".tr("^", "x").should_equal("hello x_x")
    "hello ^-^".tr("^-^", "x").should_equal("xxxxxx^-^")
    "hello ^-^".tr("^^-^", "x").should_equal("xxxxxx^x^")
    "hello ^-^".tr("^---", "x").should_equal("xxxxxxx-x")
    "hello ^-^".tr("^---l-o", "x").should_equal("xxlloxx-x")
  end
  
  it.tries "to convert from_str and to_str to strings using to_str" do
    from_str = mock('ab')
    def from_str.to_str() "ab" end

    to_str = mock('AB')
    def to_str.to_str() "AB" end
    
    "bla".tr(from_str, to_str).should_equal("BlA")

    from_str = mock('ab')
    from_str.should_receive(:respond_to?).with(:to_str).any_number_of_times.and_return(true)
    from_str.should_receive(:method_missing).with(:to_str).and_return("ab")

    to_str = mock('AB')
    to_str.should_receive(:respond_to?).with(:to_str).any_number_of_times.and_return(true)
    to_str.should_receive(:method_missing).with(:to_str).and_return("AB")

    "bla".tr(from_str, to_str).should_equal("BlA")
  end
  
  it.returns "subclass instances when called on a subclass" do
    StringSpecs::MyString.new("hello").tr("e", "a").class.should_equal(StringSpecs::MyString)
  end
  
  it.will "taint the result when self is tainted" do
    ["h", "hello"].each do |str|
      tainted_str = str.dup.taint
      
      tainted_str.tr("e", "a").tainted?.should_equal(true)
      
      str.tr("e".taint, "a").tainted?.should_equal(false)
      str.tr("e", "a".taint).tainted?.should_equal(false)
    end
  end
end

describe "String#tr!" do |it| 
  it.will "modifyself in place" do
    s = "abcdefghijklmnopqR"
    s.tr!("cdefg", "12").should_equal("ab12222hijklmnopqR")
    s.should_equal("ab12222hijklmnopqR")
  end
  
  it.returns "nil if no modification was made" do
    s = "hello"
    s.tr!("za", "yb").should_equal(nil)
    s.tr!("", "").should_equal(nil)
    s.should_equal("hello")
  end
  
  it.does_not "modify self if from_str is empty" do
    s = "hello"
    s.tr!("", "").should_equal(nil)
    s.should_equal("hello")
    s.tr!("", "yb").should_equal(nil)
    s.should_equal("hello")
  end
end
