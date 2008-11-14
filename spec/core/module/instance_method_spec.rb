# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Module#instance_method" do |it| 
  before :all do
    @parent_um = ModuleSpecs::InstanceMeth.instance_method(:foo)
    @child_um = ModuleSpecs::InstanceMethChild.instance_method(:foo)
    @mod_um = ModuleSpecs::InstanceMethChild.instance_method(:bar)
  end

  it.returns "an UnboundMethod corresponding to the given name" do
    @parent_um.class.should_equal(UnboundMethod)
    @parent_um.bind(ModuleSpecs::InstanceMeth.new).call.should_equal(:foo)
  end

  it.returns "an UnboundMethod corresponding to the given name from a superclass" do
    @child_um.class.should_equal(UnboundMethod)
    @child_um.bind(ModuleSpecs::InstanceMethChild.new).call.should_equal(:foo)
  end

  it.returns "an UnboundMethod corresponding to the given name from an included Module" do
    @mod_um.class.should_equal(UnboundMethod)
    @mod_um.bind(ModuleSpecs::InstanceMethChild.new).call.should_equal(:bar)
  end

  it.will "give UnboundMethod method name, Module defined in and Module extracted from" do
    @parent_um.inspect.should =~ /\bfoo\b/
    @parent_um.inspect.should =~ /\bModuleSpecs::InstanceMeth\b/
    @parent_um.inspect.should =~ /\bModuleSpecs::InstanceMeth\b/
    @child_um.inspect.should  =~ /\bfoo\b/
    @child_um.inspect.should  =~ /\bModuleSpecs::InstanceMeth\b/
    @child_um.inspect.should  =~ /\bModuleSpecs::InstanceMethChild\b/
    @mod_um.inspect.should    =~ /\bbar\b/
    @mod_um.inspect.should    =~ /\bModuleSpecs::InstanceMethMod\b/
    @mod_um.inspect.should    =~ /\bModuleSpecs::InstanceMethChild\b/
  end

  it.raises " a TypeError if the given name is not a string/symbol" do
    lambda { Object.instance_method(nil)       }.should_raise(TypeError)
    lambda { Object.instance_method(mock('x')) }.should_raise(TypeError)
  end

  it.raises " a NameError if the given method doesn't exist" do
    lambda { Object.instance_method(:missing) }.should_raise(NameError)
  end
end
