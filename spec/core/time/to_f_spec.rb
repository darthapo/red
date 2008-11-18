# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/methods'

describe "Time#to_f" do |it| 
  it.returns "the float number of seconds + usecs since the epoch" do
    Time.at(100, 100).to_f.should_equal(100.0001)
  end
end
