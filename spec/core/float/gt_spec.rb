# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Float#>" do |it| 
  it.returns "true if self is greater than other" do
    (1.5 > 1).should_equal(true)
    (2.5 > 3).should_equal(false)
    (45.91 > bignum_value).should_equal(false)
  end
end
