# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Float#nan?" do |it| 
  it.returns "true if self is not a valid IEEE floating-point number" do
    0.0.nan?.should_equal(false)
    -1.5.nan?.should_equal(false)
    (0.0/0.0).nan?.should_equal(true)
  end
end
