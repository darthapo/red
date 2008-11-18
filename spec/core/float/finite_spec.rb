# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Float#finite?" do |it| 
  it.returns "true if a valid IEEE floating-point number" do
    (1.5**0xffffffff).finite?.should_equal(false)
    3.14159.finite?.should_equal(true)
    (-1.0/0.0).finite?.should_equal(false)
  end
end
