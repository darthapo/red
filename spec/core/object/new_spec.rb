# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Object.new" do |it| 
  it.creates "a new Object" do
    Object.new.class.should_equal(Object)
  end
end

