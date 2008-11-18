# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/shared/to_i'

describe "Float#truncate" do |it| 
  it.behaves_like(:float_to_i, :truncate)
end
