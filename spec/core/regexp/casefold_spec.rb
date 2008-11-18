# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Regexp#casefold?" do |it| 
  it.returns "the value of the case-insensitive flag" do
    /abc/i.casefold?.should_equal(true)
    /xyz/.casefold?.should_equal(false)
  end
end
