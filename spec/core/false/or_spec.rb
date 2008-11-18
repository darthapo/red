# require File.dirname(__FILE__) + '/../../spec_helper'

describe "FalseClass#|" do |it| 
  it.returns " false if other is nil or false, otherwise true" do
    (false | false).should_equal(false)
    (false | true).should_equal(true)
    (false | nil).should_equal(false)
    (false | "").should_equal(true)
    (false | mock('x')).should_equal(true)
  end
end
