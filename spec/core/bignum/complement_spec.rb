# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Bignum#~" do |it| 
  it.returns "self with each bit flipped" do
    (~bignum_value(48)).should_equal(-9223372036854775857)
    (~(-bignum_value(21))).should_equal(9223372036854775828)
    (~bignum_value(1)).should_equal(-9223372036854775810)
  end
end
