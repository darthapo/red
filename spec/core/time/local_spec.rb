# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/methods'
# require File.dirname(__FILE__) + '/shared/local'
# require File.dirname(__FILE__) + '/shared/time_params'

describe "Time.local" do |it| 
  it.behaves_like(:time_local, :local)
  it.behaves_like(:time_params, :local)
end
