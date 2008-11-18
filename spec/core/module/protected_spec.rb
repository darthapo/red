# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Module#protected" do |it| 
  
  before :each do
    class << ModuleSpecs::Parent
      def protected_method_1; 5; end
    end
  end
  
  it.will "make an existing class method protected" do
    ModuleSpecs::Parent.protected_method_1.should_equal(5)
    
    class << ModuleSpecs::Parent
      protected :protected_method_1
    end
    
    lambda { ModuleSpecs::Parent.protected_method_1 }.should_raise(NoMethodError)
  end
  
end

