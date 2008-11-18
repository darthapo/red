describe :module_equal, :shared => true do
  it.returns "true if self and the given module are the same" do
    ModuleSpecs.send(@method, ModuleSpecs).should_equal(true)
    ModuleSpecs::Child.send(@method, ModuleSpecs::Child).should_equal(true)
    ModuleSpecs::Parent.send(@method, ModuleSpecs::Parent).should_equal(true)
    ModuleSpecs::Basic.send(@method, ModuleSpecs::Basic).should_equal(true)
    ModuleSpecs::Super.send(@method, ModuleSpecs::Super).should_equal(true)
    
    ModuleSpecs::Child.send(@method, ModuleSpecs).should_equal(false)
    ModuleSpecs::Child.send(@method, ModuleSpecs::Parent).should_equal(false)
    ModuleSpecs::Child.send(@method, ModuleSpecs::Basic).should_equal(false)
    ModuleSpecs::Child.send(@method, ModuleSpecs::Super).should_equal(false)
  end
end
