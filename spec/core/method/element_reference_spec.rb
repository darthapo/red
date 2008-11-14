# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'
# require File.dirname(__FILE__) + '/shared/call'

describe "Method#[]" do |it| 
  it.behaves_like(:method_call, :[])
end
