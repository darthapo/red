# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/shared/id2name'

describe "Symbol#to_s" do |it| 
  it.behaves_like(:symbol_id2name, :to_s)
end
