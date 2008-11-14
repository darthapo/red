# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Float#to_f" do |it| 
  it.returns "self" do
    -500.3.to_f.should_equal(-500.3)
    267.51.to_f.should_equal(267.51)
    1.1412.to_f.should_equal(1.1412)
  end
end
