# require File.dirname(__FILE__) + '/../../spec_helper'

describe "NilClass#^" do |it| 
  it.returns "false if other is nil or false, otherwise true" do
    (nil ^ nil).should_equal(false)
    (nil ^ true).should_equal(true)
    (nil ^ false).should_equal(false)
    (nil ^ "").should_equal(true)
    (nil ^ mock('x')).should_equal(true)
  end
end
