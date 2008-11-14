# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/methods'
# require File.dirname(__FILE__) + '/shared/asctime'

describe "Time#ctime" do |it| 
  it.behaves_like(:time_asctime, :ctime)
end
