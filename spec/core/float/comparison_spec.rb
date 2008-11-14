# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Float#<=>" do |it| 
  it.returns "-1, 0, 1 when self is less than, equal, or greater than other" do
    (1.5 <=> 5).should_equal(-1)
    (2.45 <=> 2.45).should_equal(0)
    ((bignum_value*1.1) <=> bignum_value).should_equal(1)
  end
end
