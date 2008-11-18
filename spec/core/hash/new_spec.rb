# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Hash.new" do |it| 
  it.creates "a new Hash with default object if pass a default argument " do
    Hash.new(5).default.should_equal(5)
    Hash.new({}).default.should_equal({})
  end

  it.does_not "create a copy of the default argument" do
    str = "foo"
    Hash.new(str).default.should_equal(str)
  end
  
  it.creates "a Hash with a default_proc if passed a block" do
    Hash.new.default_proc.should_equal(nil)
    
    h = Hash.new { |x| "Answer to #{x}" }
    h.default_proc.call(5).should_equal("Answer to 5")
    h.default_proc.call("x").should_equal("Answer to x")
  end
  
  it.raises " an ArgumentError if more than one argument is passed" do
    lambda { Hash.new(5,6) }.should_raise(ArgumentError)
  end
  
  it.raises " an ArgumentError if passed both default argument and default block" do
    lambda { Hash.new(5) { 0 }   }.should_raise(ArgumentError)
    lambda { Hash.new(nil) { 0 } }.should_raise(ArgumentError)
  end
end
