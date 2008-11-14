# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Fixnum#hash" do |it| 
  it.is "provided" do
    1.respond_to?(:hash).should_equal(true)
  end

  it.is "stable" do
    1.hash.should_equal(1.hash)
  end
end
