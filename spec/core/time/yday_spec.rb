# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/methods'

describe "Time#yday" do |it| 
  it.returns "an integer representing the day of the year, 1..366" do
    with_timezone("UTC") do
      Time.at(9999999).yday.should_equal(116)
    end
  end
end
