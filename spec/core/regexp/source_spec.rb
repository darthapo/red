# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Regexp#source" do |it| 
  it.returns "the original string of the pattern" do
    /ab+c/ix.source.should_equal("ab+c")
    /x(.)xz/.source.should_equal("x(.)xz")
  end
end
