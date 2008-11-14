# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Module#const_defined?" do |it| 
  it.returns "true if constant with the given Symbol is defined in self" do
    ModuleSpecs.const_defined?(:Child).should_equal(true)
    ModuleSpecs.const_defined?(:SomeThing).should_equal(false)
  end
  
  it.returns "true if a constant with the given String is defined in self" do
    ModuleSpecs.const_defined?("Child").should_equal(true)
    ModuleSpecs.const_defined?("SomeThing").should_equal(false)
  end

  not_compliant_on :rubinius do
    it.returns "true if a constant with the given FixNum is defined in self" do
      ModuleSpecs.const_defined?(:Child.to_i).should_equal(true)
      ModuleSpecs.const_defined?(:SomeThing.to_i).should_equal(false)
    end
  end
  
  it.tries "to convert the given name to a string using to_str" do
    (o = mock('Child')).should_receive(:to_str).and_return("Child")
    o.respond_to?(:to_str).should_equal(true)
    ModuleSpecs.const_defined?(o).should_equal(true)
  end
  
  it.raises " a NameError when the given constant name is not allowed" do
    lambda {
      ModuleSpecs.const_defined?("invalid_name")
    }.should_raise(NameError)
    
    lambda {
      ModuleSpecs.const_defined?("@invalid_name")
    }.should_raise(NameError)
  end
  
  it.raises " a TypeError when the given names can't be converted to strings using to_str" do
    o = mock('123')
    lambda { ModuleSpecs.const_defined?(o) }.should_raise(TypeError)
    
    o.should_receive(:to_str).and_return(123)
    lambda { ModuleSpecs.const_defined?(o) }.should_raise(TypeError)
  end
end
