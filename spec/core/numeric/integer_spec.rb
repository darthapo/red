# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Numeric#integer?" do |it| 
  it.returns "false" do
    NumericSub.new.integer?.should_equal(false)
  end   
end 
