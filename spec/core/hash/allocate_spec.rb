# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Hash.allocate" do |it| 
  it.returns "an instance of Hash" do
    hsh = Hash.allocate
    hsh.should_be_kind_of(Hash)
  end
  
  it.returns "a fully-formed instance of Hash" do
    hsh = Hash.allocate
    hsh.size.should_equal(0)
    hsh[:a] = 1
    hsh.should_equal({ :a => 1 })
  end
end
