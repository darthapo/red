# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Module.allocate" do |it| 
  it.returns "an instance of Module" do
    mod = Module.allocate
    mod.should_be_kind_of(Module)
  end
  
  it.returns "a fully-formed instance of Module" do
    mod = Module.allocate
    mod.constants.should_not == nil
    mod.methods.should_not == nil
  end
end
