# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/methods'
# require File.dirname(__FILE__) + '/shared/gmt_offset'

describe "Time#gmt_offset" do |it| 
  it.behaves_like(:time_gmt_offset, :gmt_offset)
end
