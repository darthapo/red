# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/shared/equal_value'

describe "Range#eql?" do |it| 
  it.behaves_like(:range_eql, :eql?)
end
