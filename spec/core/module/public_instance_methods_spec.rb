# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Module#public_instance_methods" do |it| 
  it.returns "a list of public methods in module and its ancestors" do
    methods = ModuleSpecs::CountsMixin.public_instance_methods
    methods.should_include('public_3')
  
    methods = ModuleSpecs::CountsParent.public_instance_methods
    methods.should_include('public_3')
    methods.should_include('public_2')

    methods = ModuleSpecs::CountsChild.public_instance_methods
    methods.should_include('public_3')
    methods.should_include('public_2')
    methods.should_include('public_1')

    methods = ModuleSpecs::Child2.public_instance_methods
    methods.should_include('foo')
  end

  it.can "when passed false as a parameter, should return only methods defined in that module" do
    ModuleSpecs::CountsMixin.public_instance_methods(false).should_equal(['public_3'])
    ModuleSpecs::CountsParent.public_instance_methods(false).should_equal(['public_2'])
    ModuleSpecs::CountsChild.public_instance_methods(false).should_equal(['public_1'])
  end

  it.can "default list should be the same as passing true as an argument" do
    ModuleSpecs::CountsMixin.public_instance_methods(true).should ==
      ModuleSpecs::CountsMixin.public_instance_methods
    ModuleSpecs::CountsParent.public_instance_methods(true).should ==
      ModuleSpecs::CountsParent.public_instance_methods
    ModuleSpecs::CountsChild.public_instance_methods(true).should ==
      ModuleSpecs::CountsChild.public_instance_methods
  end
end
