# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Module#<" do |it| 
  it.returns "true if self is a subclass of or includes the given module" do
    (ModuleSpecs::Child < ModuleSpecs::Parent).should_equal(true)
    (ModuleSpecs::Child < ModuleSpecs::Basic).should_equal(true)
    (ModuleSpecs::Child < ModuleSpecs::Super).should_equal(true)
    (ModuleSpecs::Super < ModuleSpecs::Basic).should_equal(true)
  end
  
  it.returns "false if self is the same as the given module" do
    (ModuleSpecs::Child  < ModuleSpecs::Child).should_equal(false)
    (ModuleSpecs::Parent < ModuleSpecs::Parent).should_equal(false)
    (ModuleSpecs::Basic  < ModuleSpecs::Basic).should_equal(false)
    (ModuleSpecs::Super  < ModuleSpecs::Super).should_equal(false)
  end
  
  it.returns "nil if self is not related to the given module" do
    (ModuleSpecs::Parent < ModuleSpecs::Basic).should_equal(nil)
    (ModuleSpecs::Parent < ModuleSpecs::Super).should_equal(nil)
    (ModuleSpecs::Basic  < ModuleSpecs::Parent).should_equal(nil)
    (ModuleSpecs::Super  < ModuleSpecs::Parent).should_equal(nil)
  end
  
  it.raises " a TypeError if the argument is not a class/module" do
    lambda { ModuleSpecs::Parent < mock('x') }.should_raise(TypeError)
  end
end
