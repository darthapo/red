# require File.dirname(__FILE__) + '/../../spec_helper'

describe "TrueClass#^" do |it| 
  it.returns "true if other is nil or false, otherwise false" do
    (true ^ true).should_equal(false)
    (true ^ false).should_equal(true)
    (true ^ nil).should_equal(true)
    (true ^ "").should_equal(false)
    (true ^ mock('x')).should_equal(false)
  end
end
