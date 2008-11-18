# require File.dirname(__FILE__) + '/../../spec_helper'

describe "String.allocate" do |it| 
  it.returns "an instance of String" do
    str = String.allocate
    str.should_be_kind_of(String)
  end
  
  it.returns "a fully-formed String" do
    str = String.allocate
    str.size.should_equal(0)
    str << "more"
    str.should_equal("more")
  end
end
