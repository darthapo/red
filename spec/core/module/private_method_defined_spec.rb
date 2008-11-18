# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Module#private_method_defined?" do |it| 
  it.returns "true if the named private method is defined by module or its ancestors" do
    ModuleSpecs::CountsMixin.private_method_defined?("private_3").should_equal(true)

    ModuleSpecs::CountsParent.private_method_defined?("private_3").should_equal(true)
    ModuleSpecs::CountsParent.private_method_defined?("private_2").should_equal(true)
    
    ModuleSpecs::CountsChild.private_method_defined?("private_3").should_equal(true)
    ModuleSpecs::CountsChild.private_method_defined?("private_2").should_equal(true)
    ModuleSpecs::CountsChild.private_method_defined?("private_1").should_equal(true)
  end

  it.returns "false if method is not a private method" do
    ModuleSpecs::CountsChild.private_method_defined?("public_3").should_equal(false)
    ModuleSpecs::CountsChild.private_method_defined?("public_2").should_equal(false)
    ModuleSpecs::CountsChild.private_method_defined?("public_1").should_equal(false)

    ModuleSpecs::CountsChild.private_method_defined?("protected_3").should_equal(false)
    ModuleSpecs::CountsChild.private_method_defined?("protected_2").should_equal(false)
    ModuleSpecs::CountsChild.private_method_defined?("protected_1").should_equal(false)
  end

  it.returns "false if the named method is not defined by the module or its ancestors" do
    ModuleSpecs::CountsMixin.private_method_defined?(:private_10).should_equal(false)
  end

  it.will "accept symbols for the method name" do
    ModuleSpecs::CountsMixin.private_method_defined?(:private_3).should_equal(true)
  end
  
  it.will "accept any argument that is a String type" do
    str = mock('string')
    def str.to_str() 'private_3' end
    ModuleSpecs::CountsMixin.private_method_defined?(str).should_equal(true)
  end
end
