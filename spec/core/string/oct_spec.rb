# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

# Note: We can't completely spec this in terms of to_int() because hex()
# allows the base to be changed by a base specifier in the string.
# See http://groups.google.com/group/ruby-core-google/browse_frm/thread/b53e9c2003425703
describe "String#oct" do |it| 
  it.will "treat leading characters of self as a string of oct digits" do
    "0".oct.should_equal(0)
    "77".oct.should_equal(077)
    "78".oct.should_equal(7)
    "077".oct.should_equal(077)
    "0o".oct.should_equal(0)

    "755_333".oct.should_equal(0755_333)
    "5678".oct.should_equal(0567)

    "0b1010".oct.should_equal(0b1010)
    "0xFF".oct.should_equal(0xFF)
    "0d500".oct.should_equal(500)
  end
  
  it.can "take an optional sign" do
    "-1234".oct.should_equal(-01234)
    "+1234".oct.should_equal(01234)
  end
  
  it.returns "0 on error" do
    "".oct.should_equal(0)
    "+-5".oct.should_equal(0)
    "wombat".oct.should_equal(0)
  end
end
