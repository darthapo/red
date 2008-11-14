# require File.dirname(__FILE__) + '/../../spec_helper'

describe "NilClass#to_f" do |it| 
  it.returns "0.0" do
    nil.to_f.should_equal(0.0)
  end
  
  it.does_not "cause NilClass to be coerced to Float" do
    (0.0 == nil).should_equal(false)
  end
end
