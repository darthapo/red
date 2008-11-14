# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'
# require File.dirname(__FILE__) + '/shared/each'

describe "String#each" do |it| 
  it.behaves_like(:string_each, :each)
end
