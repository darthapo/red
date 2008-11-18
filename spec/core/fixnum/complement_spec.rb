# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Fixnum#~" do |it| 
  it.returns "self with each bit flipped" do
    (~0).should_equal(-1)
    (~1221).should_equal(-1222)
    (~-2).should_equal(1)
    (~-599).should_equal(598)
  end
end
