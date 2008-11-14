# require File.dirname(__FILE__) + '/../../spec_helper'

describe "ArgumentError" do |it| 
  it.is_a " subclass of StandardError" do
    StandardError.should_be_ancestor_of(ArgumentError)
  end
end
