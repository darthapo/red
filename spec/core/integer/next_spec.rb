# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/shared/next'

describe "Integer#next" do |it| 
  it.behaves_like(:integer_next, :next)
end
