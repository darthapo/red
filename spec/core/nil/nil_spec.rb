# require File.dirname(__FILE__) + '/../../spec_helper'

describe "NilClass#nil?" do |it| 
  it.returns "true" do
    nil.nil?.should_equal(true)
  end
end
