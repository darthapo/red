# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Precision#prec_i" do |it| 
  it.returns "the same Integer when called on an Integer"  do
    1.prec_i.should_equal(1)
  end

  it.can "convert Float to an Integer when called on an Integer" do
    1.9.prec_i.should_equal(1)
  end
end