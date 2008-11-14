# require File.dirname(__FILE__) + '/../../spec_helper'

describe "IOError" do |it| 
  it.is_a " superclass of EOFError" do
    IOError.should_be_ancestor_of(EOFError)
  end
end
