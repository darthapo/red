# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#dump" do |it| 
  # Older versions of MRI wrongly print \b as \010
  it.will "produce a version of self with all nonprinting charaters replaced by \\nnn notation" do
    ("\000".."A").to_a.to_s.dump.should_equal("\"\\000\\001\\002\\003\\004\\005\\006\\a\\b\\t\\n\\v\\f\\r\\016\\017\\020\\021\\022\\023\\024\\025\\026\\027\\030\\031\\032\\e\\034\\035\\036\\037 !\\\"\\\#$%&'()*+,-./0123456789\"")
  end
  
  it.will "ignore the $KCODE setting" do
    old_kcode = $KCODE

    begin
      $KCODE = "NONE"
      "äöü".dump.should_equal("\"\\303\\244\\303\\266\\303\\274\"")

      $KCODE = "UTF-8"
      "äöü".dump.should_equal("\"\\303\\244\\303\\266\\303\\274\"")
    ensure
      $KCODE = old_kcode
    end
  end

  it.will "taint result when self is tainted" do
    "".taint.dump.tainted?.should_equal(true)
    "x".taint.dump.tainted?.should_equal(true)
  end
  
  it.returns "a subclass instance for subclasses" do
    StringSpecs::MyString.new("hi!").dump.class.should_equal(StringSpecs::MyString)
  end
end
