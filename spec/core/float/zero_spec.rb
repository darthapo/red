# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Float#zero?" do |it| 
  it.returns "true if self is 0.0" do
    0.0.zero?.should_equal(true)
    1.0.zero?.should_equal(false)
    -1.0.zero?.should_equal(false)
  end
end
