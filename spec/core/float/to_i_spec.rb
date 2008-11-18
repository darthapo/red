# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/shared/to_i'

describe "Float#to_i" do |it| 
  it.behaves_like(:float_to_i, :to_i)
end
