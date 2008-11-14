# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Module#private_instance_methods" do |it| 
  it.returns "a list of private methods in module and its ancestors" do
    methods = ModuleSpecs::CountsMixin.private_instance_methods
    methods.should_include('private_3')
  
    methods = ModuleSpecs::CountsParent.private_instance_methods
    methods.should_include('private_3')
    methods.should_include('private_2')

    methods = ModuleSpecs::CountsChild.private_instance_methods
    methods.should_include('private_3')
    methods.should_include('private_2')
    methods.should_include('private_1')
  end

  it.can "when passed false as a parameter, should return only methods defined in that module" do
    ModuleSpecs::CountsMixin.private_instance_methods(false).should_equal(['private_3'])
    ModuleSpecs::CountsParent.private_instance_methods(false).should_equal(['private_2'])
    ModuleSpecs::CountsChild.private_instance_methods(false).should_equal(['private_1'])
  end

  it.can "default list should be the same as passing true as an argument" do
    ModuleSpecs::CountsMixin.private_instance_methods(true).should ==
      ModuleSpecs::CountsMixin.private_instance_methods
    ModuleSpecs::CountsParent.private_instance_methods(true).should ==
      ModuleSpecs::CountsParent.private_instance_methods
    ModuleSpecs::CountsChild.private_instance_methods(true).should ==
      ModuleSpecs::CountsChild.private_instance_methods
  end
end
