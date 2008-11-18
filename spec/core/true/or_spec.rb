# require File.dirname(__FILE__) + '/../../spec_helper'

describe "TrueClass#|" do |it| 
  it.returns "true" do
    (true | true).should_equal(true)
    (true | false).should_equal(true)
    (true | nil).should_equal(true)
    (true | "").should_equal(true)
    (true | mock('x')).should_equal(true)
  end
end
