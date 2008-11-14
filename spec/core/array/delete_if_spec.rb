# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Array#delete_if" do |it| 
  before do
    @a = [ "a", "b", "c" ] 
  end

  it.will "remove each element for which block returns true" do
    @a = [ "a", "b", "c" ] 
    @a.delete_if { |x| x >= "b" }
    @a.should_equal(["a"])
  end

  it.returns "self" do
    @a.delete_if{ true }.equal?(@a).should_be_true
  end

  it.will "keep its tainted status" do
    @a.taint
    @a.tainted?.should_be_true
    @a.delete_if{ true }
    @a.tainted?.should_be_true
  end
end
