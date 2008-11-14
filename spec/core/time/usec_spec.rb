# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/methods'

describe "Time#usec" do |it| 
  it.returns "the microseconds for time" do
    Time.at(0).usec.should_equal(0)
    (Time.at(1.1) + 0.9).usec.should_equal(0)
    (Time.at(1.1) - 0.2).usec.should_equal(900000)
  end
end
