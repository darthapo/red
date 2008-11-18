# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'
# require File.dirname(__FILE__) + '/shared/iteration'
# require File.dirname(__FILE__) + '/shared/update'

describe "Hash#update" do |it| 
  it.behaves_like(:hash_update, :update)

  it.behaves_like(:hash_iteration_method, :update)
end
