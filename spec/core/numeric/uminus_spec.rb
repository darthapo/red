# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Numeric#-@" do     |it| 
  it.should "return the same value with opposite sign (integers)" do 
    0.send(:-@).should_equal(0)
    100.send(:-@).should_equal(-100)
    -100.send(:-@).should_equal(100 )
  end  

  it.should "return the same value with opposite sign (floats)" do 
    34.56.send(:-@).should_equal(-34.56)
    -34.56.send(:-@).should_equal(34.56)
  end   

  it.should "return the same value with opposite sign (two complement)" do 
    2147483648.send(:-@).should_equal(-2147483648)
    -2147483648.send(:-@).should_equal(2147483648)
    9223372036854775808.send(:-@).should_equal(-9223372036854775808)
    -9223372036854775808.send(:-@).should_equal(9223372036854775808)
  end  
end
