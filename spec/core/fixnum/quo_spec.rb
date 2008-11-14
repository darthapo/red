# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Fixnum#quo" do |it| 
  it.returns "the result of self divided by the given Integer as a Float" do
    2.quo(2.5).should_equal(0.8)
    5.quo(2).should_equal(2.5)
    45.quo(bignum_value).should_be_close(1.04773789668636e-08, TOLERANCE)
  end
end
