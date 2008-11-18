# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#empty?" do |it| 
  it.returns "true if the string has a length of zero" do
    "hello".empty?.should_equal(false)
    " ".empty?.should_equal(false)
    "\x00".empty?.should_equal(false)
    "".empty?.should_equal(true)
    StringSpecs::MyString.new("").empty?.should_equal(true)
  end
end
