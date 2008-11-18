# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Module#remove_const" do |it| 
  it.returns "the value of the removed constant" do
    ModuleSpecs::Internal::ONE = 1
    ModuleSpecs::Internal.send(:remove_const, :ONE).should_equal(1)
    lambda { ModuleSpecs::Internal.send(:remove_const, :ONE) }.should_raise(NameError)
  end

  it.is_a " private method" do 
    ModuleSpecs::Internal::TWO = 2
    lambda { ModuleSpecs::Internal.remove_const(:TWO) }.should_raise(NameError)
    ModuleSpecs::Internal.send(:remove_const, :TWO).should_equal(2)
  end
end

