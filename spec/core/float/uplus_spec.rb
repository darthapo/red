# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Float#+@" do  |it| 
  it.returns "the same value with same sign (twos complement)" do 
    34.56.send(:+@).should_equal(34.56)
    -34.56.send(:+@).should_equal(-34.56)
    0.0.send(:+@).should_equal(0.0)
  end  
end
