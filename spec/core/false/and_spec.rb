# require File.dirname(__FILE__) + '/../../spec_helper'

describe "FalseClass#&" do |it| 
  it.returns "false" do
    (false & false).should_equal(false)
    (false & true).should_equal(false)
    (false & nil).should_equal(false)
    (false & "").should_equal(false)
    (false & mock('x')).should_equal(false)
  end
end
