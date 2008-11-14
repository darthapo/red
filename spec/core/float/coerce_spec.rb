# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Float#coerce" do |it| 
  it.returns "[other, self] both as Floats" do
    1.2.coerce(1).should_equal([1.0, 1.2])
    5.28.coerce(1.0).should_equal([1.0, 5.28])
    1.0.coerce(1).should_equal([1.0, 1.0])
    1.0.coerce("2.5").should_equal([2.5, 1.0])
    1.0.coerce(3.14).should_equal([3.14, 1.0])

    a, b = -0.0.coerce(bignum_value)
    a.should_be_close(9223372036854775808.000, TOLERANCE)
    b.should_be_close(-0.0, TOLERANCE)
    a, b = 1.0.coerce(bignum_value)
    a.should_be_close(9223372036854775808.000, TOLERANCE)
    b.should_be_close(1.0, TOLERANCE)
  end
end
