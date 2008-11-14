# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'
# require File.dirname(__FILE__) + '/shared/replace'

describe "Hash#replace" do |it| 
  it.behaves_like(:hash_replace, :replace)
end
