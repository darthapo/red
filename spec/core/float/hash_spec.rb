# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Float#hash" do |it| 
  it.is "provided" do
    0.0.respond_to?(:hash).should_equal(true)
  end

  it.is "stable" do
    1.0.hash.should_equal(1.0.hash)
  end
end
