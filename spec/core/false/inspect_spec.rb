# require File.dirname(__FILE__) + '/../../spec_helper'

describe "FalseClass#inspect" do |it| 
  it.returns "the string 'false'" do
    false.inspect.should_equal("false")
  end
end
