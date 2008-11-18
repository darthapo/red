# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Float#ceil" do |it| 
  it.returns "the smallest Integer greater than or equal to self" do
    -1.2.ceil.should_equal(-1)
    -1.0.ceil.should_equal(-1)
    0.0.ceil.should_equal(0)
    1.3.ceil.should_equal(2)
    3.0.ceil.should_equal(3)
    -9223372036854775808.1.ceil.should_equal(-9223372036854775808)
    9223372036854775808.1.ceil.should_equal(9223372036854775808)
  end
end
