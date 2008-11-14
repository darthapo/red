# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Float#prec" do |it| 
  it.returns "the same Float when given the class Float" do
    1.4.prec(Float).should_equal(1.4)
  end

  it.can "convert the Float to an Integer when given the class Integer" do
    1.4.prec(Integer).should_equal(1)
  end
end

describe "Integer#prec" do |it| 
  it.returns "the same Integer when given the class Integer" do
    1.prec(Integer).should_equal(1)
  end

  it.can "convert the Integer to Float when given the class Float" do
    1.prec(Float).should_equal(1.0)
  end
end

