# require File.dirname(__FILE__) + '/../../spec_helper'

describe "FalseClass#to_s" do |it| 
  it.returns "the string 'false'" do
    false.to_s.should_equal("false")
  end
end
