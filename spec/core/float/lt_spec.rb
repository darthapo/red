# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Float#<" do |it| 
  it.returns "true if self is less than other" do
    (71.3 < 91.8).should_equal(true)
    (192.6 < -500).should_equal(false)
    (-0.12 < 0x4fffffff).should_equal(true)
  end
end
