# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Module#===" do |it| 
  it.returns "true when the given Object is an instance of self or of self's descendants" do
    (ModuleSpecs::Child       === ModuleSpecs::Child.new).should_equal(true)
    (ModuleSpecs::Parent      === ModuleSpecs::Parent.new).should_equal(true)
    
    (ModuleSpecs::Parent      === ModuleSpecs::Child.new).should_equal(true)
    (Object                   === ModuleSpecs::Child.new).should_equal(true)

    (ModuleSpecs::Child       === String.new).should_equal(false)
    (ModuleSpecs::Child       === mock('x')).should_equal(false)
  end
  
  it.returns "true when the given Object's class includes self or when the given Object is extended by self" do
    (ModuleSpecs::Basic === ModuleSpecs::Child.new).should_equal(true)
    (ModuleSpecs::Super === ModuleSpecs::Child.new).should_equal(true)
    (ModuleSpecs::Basic === mock('x').extend(ModuleSpecs::Super)).should_equal(true)
    (ModuleSpecs::Super === mock('y').extend(ModuleSpecs::Super)).should_equal(true)

    (ModuleSpecs::Basic === ModuleSpecs::Parent.new).should_equal(false)
    (ModuleSpecs::Super === ModuleSpecs::Parent.new).should_equal(false)
    (ModuleSpecs::Basic === mock('z')).should_equal(false)
    (ModuleSpecs::Super === mock('a')).should_equal(false)
  end
end
