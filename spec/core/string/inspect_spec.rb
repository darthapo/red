# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#inspect" do |it| 
  # Older versions of MRI wrongly print \b as \010
  it.will "produce a version of self with all nonprinting charaters replaced by \\nnn notation" do
    ("\000".."A").to_a.to_s.inspect.should_equal("\"\\000\\001\\002\\003\\004\\005\\006\\a\\b\\t\\n\\v\\f\\r\\016\\017\\020\\021\\022\\023\\024\\025\\026\\027\\030\\031\\032\\e\\034\\035\\036\\037 !\\\"\\\#$%&'()*+,-./0123456789\"")
  end
  
  it.will "produce different output based on $KCODE" do
    old_kcode = $KCODE

    begin
      $KCODE = "NONE"
      "äöü".inspect.should_equal("\"\\303\\244\\303\\266\\303\\274\"")

      $KCODE = "UTF-8"
      "äöü".inspect.should_equal("\"äöü\"")
    ensure
      $KCODE = old_kcode
    end
  end

  it.can "handle malformed UTF-8 string when $KCODE is UTF-8" do
    old_kcode = $KCODE

    begin
      $KCODE = "UTF-8"
      # malformed UTF-8 sequence
      "\007äöüz\303".inspect.should_equal("\"\\aäöüz\\303\"")
    ensure
      $KCODE = old_kcode
    end
  end

  it.will "taint the result if self is tainted" do
    "foo".taint.inspect.tainted?.should_equal(true)
    "foo\n".taint.inspect.tainted?.should_equal(true)
  end

  it.does_not "return subclass instances" do
    str = StringSpecs::MyString.new
    str << "test"
    str.should_equal("test")
    str.inspect.class.should_not == StringSpecs::MyString
  end
end
