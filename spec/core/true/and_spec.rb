# require File.dirname(__FILE__) + '/../../spec_helper'

describe "TrueClass#&" do |it| 
  it.returns "false if other is nil or false, otherwise true" do
    (true & true).should_equal(true)
    (true & false).should_equal(false)
    (true & nil).should_equal(false)
    (true & "").should_equal(true)
    (true & mock('x')).should_equal(true)
  end
end
