# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Fixnum#zero?" do |it| 
  it.returns "true if self is 0" do
    0.zero?.should_equal(true)
    -1.zero?.should_equal(false)
    1.zero?.should_equal(false)
  end  
end
