# require File.dirname(__FILE__) + '/../../spec_helper'

describe "NilClass#&" do |it| 
  it.returns "false" do
    (nil & nil).should_equal(false)
    (nil & true).should_equal(false)
    (nil & false).should_equal(false)
    (nil & "").should_equal(false)
    (nil & mock('x')).should_equal(false)
  end
end
