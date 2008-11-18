# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Float#<=" do |it| 
  it.returns "true if self is less than or equal to other" do
    (2.0 <= 3.14159).should_equal(true)
    (-2.7183 <= -24).should_equal(false)
    (0.0 <= 0.0).should_equal(true)
    (9_235.9 <= bignum_value).should_equal(true)
  end
end
