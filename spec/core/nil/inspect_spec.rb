# require File.dirname(__FILE__) + '/../../spec_helper'

describe "NilClass#inspect" do |it| 
  it.returns "the string 'nil'" do
    nil.inspect.should_equal("nil")
  end
end
