# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#squeeze" do |it| 
  it.returns "new string where runs of the same character are replaced by a single character when no args are given" do
    "yellow moon".squeeze.should_equal("yelow mon")
  end
  
  it.will "only squeeze chars that are in the intersection of all sets given" do
    "woot squeeze cheese".squeeze("eost", "queo").should_equal("wot squeze chese")
    "  now   is  the".squeeze(" ").should_equal(" now is the")
  end
  
  it.can "negates sets starting with ^" do
    s = "<<subbookkeeper!!!>>"
    s.squeeze("beko", "^e").should_equal(s.squeeze("bko"))
    s.squeeze("^<bek!>").should_equal(s.squeeze("o"))
    s.squeeze("^o").should_equal(s.squeeze("<bek!>"))
    s.squeeze("^").should_equal(s)
    "^__^".squeeze("^^").should_equal("^_^")
    "((^^__^^))".squeeze("_^").should_equal("((^_^))")
  end
  
  it.will "squeeze all chars in a sequence" do
    s = "--subbookkeeper--"
    s.squeeze("\x00-\xFF").should_equal(s.squeeze)
    s.squeeze("bk-o").should_equal(s.squeeze("bklmno"))
    s.squeeze("b-e").should_equal(s.squeeze("bcde"))
    s.squeeze("e-").should_equal("-subbookkeper-")
    s.squeeze("-e").should_equal("-subbookkeper-")
    s.squeeze("---").should_equal("-subbookkeeper-")
    "ook--001122".squeeze("--2").should_equal("ook-012")
    "ook--(())".squeeze("(--").should_equal("ook-()")
    s.squeeze("e-b").should_equal(s)
    s.squeeze("^e-b").should_equal(s.squeeze)
    s.squeeze("^b-e").should_equal("-subbokeeper-")
    "^^__^^".squeeze("^^-^").should_equal("^^_^^")
    "^^--^^".squeeze("^---").should_equal("^--^")
    
    s.squeeze("b-dk-o-").should_equal("-subokeeper-")
    s.squeeze("-b-dk-o").should_equal("-subokeeper-")
    s.squeeze("b-d-k-o").should_equal("-subokeeper-")
    
    s.squeeze("bc-e").should_equal("--subookkeper--")
    s.squeeze("^bc-e").should_equal("-subbokeeper-")

    "AABBCCaabbcc[[]]".squeeze("A-a").should_equal("ABCabbcc[]")
  end
  
  it.will "taint the result when self is tainted" do
    "hello".taint.squeeze("e").tainted?.should_equal(true)
    "hello".taint.squeeze("a-z").tainted?.should_equal(true)

    "hello".squeeze("e".taint).tainted?.should_equal(false)
    "hello".squeeze("l".taint).tainted?.should_equal(false)
  end
  
  it.tries "to convert each set arg to a string using to_str" do
    other_string = mock('lo')
    def other_string.to_str() "lo" end
    
    other_string2 = mock('o')
    def other_string2.to_str() "o" end
    
    "hello room".squeeze(other_string, other_string2).should_equal("hello rom")

    obj = mock('o')
    obj.should_receive(:respond_to?).with(:to_str).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_str).and_return("o")
    "hello room".squeeze(obj).should_equal("hello rom")
  end
  
  it.raises " a TypeError when one set arg can't be converted to a string" do
    lambda { "hello world".squeeze(?o)        }.should_raise(TypeError)
    lambda { "hello world".squeeze(:o)        }.should_raise(TypeError)
    lambda { "hello world".squeeze(mock('x')) }.should_raise(TypeError)
  end
  
  it.returns "subclass instances when called on a subclass" do
    StringSpecs::MyString.new("oh no!!!").squeeze("!").class.should_equal(StringSpecs::MyString)
  end
end

describe "String#squeeze!" do |it| 
  it.will "modifyself in place and returns self" do
    a = "yellow moon"
    a.squeeze!.should_equal(a)
    a.should_equal("yelow mon")
  end
  
  it.returns "nil if no modifications were made" do
    a = "squeeze"
    a.squeeze!("u", "sq").should_equal(nil)
    a.squeeze!("q").should_equal(nil)
    a.should_equal("squeeze")
  end

end
