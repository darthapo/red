# require File.dirname(__FILE__) + '/../../spec_helper'

describe "NilClass#to_s" do |it| 
  it.returns "the string ''" do
    nil.to_s.should_equal("")
  end
end
