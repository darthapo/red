# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Bignum#**" do |it| 
  before(:each) do
    @bignum = bignum_value(47)
  end
  
  it.returns "self raised to other power" do
    (@bignum ** 4).should_equal(7237005577332262361485077344629993318496048279512298547155833600056910050625)
    (@bignum ** 1.2).should_be_close(57262152889751597425762.57804, TOLERANCE)
  end

  it.raises " a TypeError when given a non-Integer" do
    lambda { @bignum ** mock('10') }.should_raise
    lambda { @bignum ** "10" }.should_raise
    lambda { @bignum ** :symbol }.should_raise
  end
end
