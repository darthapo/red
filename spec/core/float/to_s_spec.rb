# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Float#to_s" do |it| 
  it.returns "a string representation of self, possibly Nan, -Infinity, +Infinity" do
    0.551e7.to_s.should_equal("5510000.0")
    -3.14159.to_s.should_equal("-3.14159")
    0.0.to_s.should_equal("0.0")
    1000000000000.to_f.to_s.should_equal("1000000000000.0")
    10000000000000.to_f.to_s.should_equal("10000000000000.0")
    100000000000000.to_f.to_s.should_equal("1.0e+14")
    -10000000000000.to_f.to_s.should_equal("-10000000000000.0")
    -100000000000000.to_f.to_s.should_equal("-1.0e+14")
    1.87687113714737e-40.to_s.should_equal("1.87687113714737e-40")
    (0.0 / 0.0).to_s.should_equal("NaN")
    (1.0 / 0.0).to_s.should_equal("Infinity")
    (-1.0 / 0.0).to_s.should_equal("-Infinity")
    1.50505000e-20.to_s.should_equal("1.50505e-20")
  end
  
  it.returns "the correct values for -0.0" do
    -0.0.to_s.should_equal("-0.0")
  end
end
