# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Array#empty?" do |it| 
  it.returns "true if the array has no elements" do
    [].empty?.should_equal(true)
    [1].empty?.should_equal(false)
    [1, 2].empty?.should_equal(false)
  end
end
