# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/shared/end'

describe "Range#last" do |it| 
  it.behaves_like(:range_end, :last)
end
