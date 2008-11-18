# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/shared/begin'

describe "Range#begin" do |it| 
  it.behaves_like(:range_begin, :begin)
end
