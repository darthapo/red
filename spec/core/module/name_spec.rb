# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Module#name" do |it| 
  it.returns "the name of self" do
    Module.new.name.should_equal("")
    Class.new.name.should_equal("")
    
    ModuleSpecs.name.should_equal("ModuleSpecs")
    ModuleSpecs::Child.name.should_equal("ModuleSpecs::Child")
    ModuleSpecs::Parent.name.should_equal("ModuleSpecs::Parent")
    ModuleSpecs::Basic.name.should_equal("ModuleSpecs::Basic")
    ModuleSpecs::Super.name.should_equal("ModuleSpecs::Super")
    
    begin
      (ModuleSpecs::X = Module.new).name.should_equal("ModuleSpecs::X")
    ensure
      ModuleSpecs.send :remove_const, :X
    end
  end
end
