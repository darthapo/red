# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'
# require File.dirname(__FILE__) + '/shared/length'

describe "Array#length" do |it| 
  it.behaves_like(:array_length, :length)
end
