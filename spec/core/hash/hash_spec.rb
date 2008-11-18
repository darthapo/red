# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Hash" do |it| 
  it.can "includes Enumerable" do
    Hash.include?(Enumerable).should_equal(true)
  end
end

