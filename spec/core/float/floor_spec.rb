# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Float#floor" do |it| 
  it.returns "the largest Integer less than or equal to self" do
    -1.2.floor.should_equal(-2)
    -1.0.floor.should_equal(-1)
    0.0.floor.should_equal(0)
    1.0.floor.should_equal(1)
    5.9.floor.should_equal(5)
    -9223372036854775808.1.floor.should_equal(-9223372036854775808)
    9223372036854775808.1.floor.should_equal(9223372036854775808)
  end
end
