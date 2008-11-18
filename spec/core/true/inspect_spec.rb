# require File.dirname(__FILE__) + '/../../spec_helper'

describe "TrueClass#inspect" do |it| 
  it.returns "the string 'true'" do
    true.inspect.should_equal("true")
  end
end
