# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/methods'
# require File.dirname(__FILE__) + '/shared/local'
# require File.dirname(__FILE__) + '/shared/time_params'

describe "Time.mktime" do |it| 
  it.behaves_like(:time_local, :mktime)
  it.behaves_like(:time_params, :mktime)
end
