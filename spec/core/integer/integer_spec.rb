# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Integer#integer?" do |it| 
  it.returns "true" do
    0.integer?.should_equal(true )
    -1.integer?.should_equal(true)
    bignum_value.integer?.should_equal(true)
  end
end
