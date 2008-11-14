# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Module#<=>" do |it| 
  it.returns "-1 if self is a subclass of or includes the given module" do
    (ModuleSpecs::Child <=> ModuleSpecs::Parent).should_equal(-1)
    (ModuleSpecs::Child <=> ModuleSpecs::Basic).should_equal(-1)
    (ModuleSpecs::Child <=> ModuleSpecs::Super).should_equal(-1)
    (ModuleSpecs::Super <=> ModuleSpecs::Basic).should_equal(-1)
  end
  
  it.returns "0 if self is the same as the given module" do
    (ModuleSpecs::Child  <=> ModuleSpecs::Child).should_equal(0)
    (ModuleSpecs::Parent <=> ModuleSpecs::Parent).should_equal(0)
    (ModuleSpecs::Basic  <=> ModuleSpecs::Basic).should_equal(0)
    (ModuleSpecs::Super  <=> ModuleSpecs::Super).should_equal(0)
  end
  
  it.returns "+1 if self is a superclas of or included by the given module" do
    (ModuleSpecs::Parent <=> ModuleSpecs::Child).should_equal(+1)
    (ModuleSpecs::Basic  <=> ModuleSpecs::Child).should_equal(+1)
    (ModuleSpecs::Super  <=> ModuleSpecs::Child).should_equal(+1)
    (ModuleSpecs::Basic  <=> ModuleSpecs::Super).should_equal(+1)
  end
  
  it.returns "nil if self and the given module are not related" do
    (ModuleSpecs::Parent <=> ModuleSpecs::Basic).should_equal(nil)
    (ModuleSpecs::Parent <=> ModuleSpecs::Super).should_equal(nil)
    (ModuleSpecs::Basic  <=> ModuleSpecs::Parent).should_equal(nil)
    (ModuleSpecs::Super  <=> ModuleSpecs::Parent).should_equal(nil)
  end
  
  it.returns "nil if the argument is not a class/module" do
    (ModuleSpecs::Parent <=> mock('x')).should_equal(nil)
  end
end
