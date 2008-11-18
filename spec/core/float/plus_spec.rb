# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Float#+" do |it| 
  it.returns "self plus other" do
    (491.213 + 2).should_be_close(493.213, TOLERANCE)
    (9.99 + bignum_value).should_be_close(9223372036854775808.000, TOLERANCE)
    (1001.99 + 5.219).should_be_close(1007.209, TOLERANCE)
  end
end
