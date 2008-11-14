# require File.dirname(__FILE__) + '/../../spec_helper'

describe "NilClass#to_i" do |it| 
  it.returns "0" do
    nil.to_i.should_equal(0)
  end
  
  it.does_not "cause NilClass to be coerced to Fixnum" do
    (0 == nil).should_equal(false)
  end
end
