# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#reverse" do |it| 
  it.returns "a new string with the characters of self in reverse order" do
    "stressed".reverse.should_equal("desserts")
    "m".reverse.should_equal("m")
    "".reverse.should_equal("")
  end
  
  it.will "taint the result if self is tainted" do
    "".taint.reverse.tainted?.should_equal(true)
    "m".taint.reverse.tainted?.should_equal(true)
  end
end

describe "String#reverse!" do |it| 
  it.will "reverse self in place and always returns self" do
    a = "stressed"
    a.reverse!.should_equal(a)
    a.should_equal("desserts")
    
    "".reverse!.should_equal("")
  end
end
