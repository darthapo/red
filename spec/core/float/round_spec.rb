# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Float#round" do |it| 
  it.returns "the nearest Integer" do
    5.5.round.should_equal(6)
    0.4.round.should_equal(0)
    -2.8.round.should_equal(-3)
    0.0.round.should_equal(0)
  end
end
