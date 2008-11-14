# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Float#>=" do |it| 
  it.returns "true if self is greater than or equal to other" do
    (5.2 >= 5.2).should_equal(true)
    (9.71 >= 1).should_equal(true)
    (5.55382 >= 0xfabdafbafcab).should_equal(false)
  end
end
