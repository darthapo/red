# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Class#superclass" do |it| 
  it.returns "the superclass of self" do
    Object.superclass.should_equal(nil)
    Class.superclass.should_equal(Module)
    Class.new.superclass.should_equal(Object)
    Class.new(String).superclass.should_equal(String)
    Class.new(Fixnum).superclass.should_equal(Fixnum)
  end
end