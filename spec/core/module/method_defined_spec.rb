# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Module#method_defined?" do |it| 
  it.returns "true if a public or private method with the given name is defined in self, self's ancestors or one of self's included modules" do
    # Defined in Child
    ModuleSpecs::Child.method_defined?(:public_child).should_equal(true)
    ModuleSpecs::Child.method_defined?("private_child").should_equal(false)
    ModuleSpecs::Child.method_defined?(:accessor_method).should_equal(true)

    # Defined in Parent
    ModuleSpecs::Child.method_defined?("public_parent").should_equal(true)
    ModuleSpecs::Child.method_defined?(:private_parent).should_equal(false)

    # Defined in Module
    ModuleSpecs::Child.method_defined?(:public_module).should_equal(true)
    ModuleSpecs::Child.method_defined?(:protected_module).should_equal(true)
    ModuleSpecs::Child.method_defined?(:private_module).should_equal(false)

    # Defined in SuperModule
    ModuleSpecs::Child.method_defined?(:public_super_module).should_equal(true)
    ModuleSpecs::Child.method_defined?(:protected_super_module).should_equal(true)
    ModuleSpecs::Child.method_defined?(:private_super_module).should_equal(false)
  end

  it.raises " a TypeError when the given object is not a string/symbol/fixnum" do
    c = Class.new
    o = mock('123')
    
    lambda { c.method_defined?(o) }.should_raise(TypeError)
    
    o.should_receive(:to_str).and_return(123)
    lambda { c.method_defined?(o) }.should_raise(TypeError)
  end
  
  it.can "convert the given name to a string using to_str" do
    c = Class.new { def test(); end }
    (o = mock('test')).should_receive(:to_str).and_return("test")
    
    c.method_defined?(o).should_equal(true)
  end
end
