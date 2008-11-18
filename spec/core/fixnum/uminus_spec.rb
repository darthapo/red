# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Fixnum#-@" do |it| 
  it.returns "self as a negative value" do
    2.send(:-@).should_equal(-2)
    -2.should_equal(-2)
    -268435455.should_equal(-268435455)
    (--5).should_equal(5)
    -8.send(:-@).should_equal(8)
  end
end
