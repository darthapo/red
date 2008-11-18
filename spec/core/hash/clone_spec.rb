# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Hash#clone" do |it| 
  it.can "copies instance variable but not the objects they refer to" do
    hash = { 'key' => 'value' }

    clone = hash.clone

    clone.should_equal(hash)
    clone.object_id.should_not == hash.object_id
  end
end

