# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'
# require File.dirname(__FILE__) + '/shared/length'

describe "String#size" do |it| 
  it.behaves_like(:string_length, :size)
end