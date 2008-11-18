# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Module#protected_instance_methods" do |it| 
  it.returns "a list of protected methods in module and its ancestors" do
    methods = ModuleSpecs::CountsMixin.protected_instance_methods
    methods.should_include('protected_3')
  
    methods = ModuleSpecs::CountsParent.protected_instance_methods
    methods.should_include('protected_3')
    methods.should_include('protected_2')

    methods = ModuleSpecs::CountsChild.protected_instance_methods
    methods.should_include('protected_3')
    methods.should_include('protected_2')
    methods.should_include('protected_1')
  end

  it.can "when passed false as a parameter, should return only methods defined in that module" do
    ModuleSpecs::CountsMixin.protected_instance_methods(false).should_equal(['protected_3'])
    ModuleSpecs::CountsParent.protected_instance_methods(false).should_equal(['protected_2'])
    ModuleSpecs::CountsChild.protected_instance_methods(false).should_equal(['protected_1'])
  end

  it.can "default list should be the same as passing true as an argument" do
    ModuleSpecs::CountsMixin.protected_instance_methods(true).should ==
      ModuleSpecs::CountsMixin.protected_instance_methods
    ModuleSpecs::CountsParent.protected_instance_methods(true).should ==
      ModuleSpecs::CountsParent.protected_instance_methods
    ModuleSpecs::CountsChild.protected_instance_methods(true).should ==
      ModuleSpecs::CountsChild.protected_instance_methods
  end
end
