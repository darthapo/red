# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/shared/equal_value'

describe "Range#==" do |it| 
  it.behaves_like(:range_eql, :==)
end
