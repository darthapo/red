# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Module#const_get" do |it| 
  it.returns "the named constant in the receiver module when name given as String" do
    ModuleSpecs.const_get("Lookup").should_equal(ModuleSpecs::Lookup)
  end

  it.returns "the named constant in the receiver module when name given as Symbol" do
    ModuleSpecs::Lookup.const_get(:LOOKIE).should_equal(ModuleSpecs::Lookup::LOOKIE)
  end

  it.returns "the named constant in any superclass of a receiver Class" do
    ModuleSpecs::LookupChild.const_get(:LOOKIE).should_equal(ModuleSpecs::Lookup::LOOKIE)
    ModuleSpecs::LookupChild.const_get(:MODS).should_equal(ModuleSpecs::LookupMod::MODS)
  end

  it.returns "the named constant in any included module in receiver's ancestry" do
    ModuleSpecs::LookupMod.const_get(:INCS).should_equal(ModuleSpecs::LookupModInMod::INCS)
    ModuleSpecs::LookupChild.const_get(:INCS).should_equal(ModuleSpecs::LookupModInMod::INCS)
  end

  it.returns "the named top-level constant for a receiver Class (since it is < Object)" do
    Object.const_get(:TopLevelConst).should_equal(TopLevelConst)
    ModuleSpecs::LookupChild.const_get(:TopLevelConst).should_equal(TopLevelConst)
  end

  it.returns "the named top-level constant for a receiver Module" do
    Object.const_get(:TopLevelConst).should_equal(TopLevelConst)
    ModuleSpecs::LookupMod.const_get(:TopLevelConst).should_equal(TopLevelConst)
  end

  it.raises " a NameError when there is no constant with the given name" do
    lambda { ModuleSpecs.const_get("NotExistant") }.should_raise(NameError)
  end

  it.tries "to convert any non-String/Symbol 'name' with #to_str" do
    (o = mock('Parent')).should_receive(:to_str).and_return("Parent")
    ModuleSpecs.const_get(o).should_equal(ModuleSpecs::Parent)
  end

  it.raises " a TypeError when the given object does not respond to or fails #to_str" do
    o = mock('123')
    lambda { ModuleSpecs.const_get(o) }.should_raise(TypeError)

    o.should_receive(:to_str).and_return(123)
    lambda { ModuleSpecs.const_get(o) }.should_raise(TypeError)
  end
end
