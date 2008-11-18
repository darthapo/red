# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Math::PI" do |it| 
  it.will "approximate the value of pi" do
    Math::PI.should_be_close(3.14159_26535_89793_23846, TOLERANCE)
  end
  
  it.is "accessible to a class that includes Math" do
    IncludesMath::PI.should_equal(Math::PI)
  end
end

describe "Math::E" do |it| 
  it.will "approximate the value of Napier's constant" do
    Math::E.should_be_close(2.71828_18284_59045_23536, TOLERANCE)
  end

  it.is "accessible to a class that includes Math" do
    IncludesMath::E.should_equal(Math::E)
  end
end
