# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Module#method_added" do |it| 
  it.is_a " private instance method" do
    Module.private_instance_methods.should_include("method_added")
  end
  
  it.returns "nil in the default implementation" do
    Module.new do
      method_added(:test).should_equal(nil)
    end
  end
  
  it.is "called when a new method is defined in self" do
    begin
      $methods_added = []
      
      m = Module.new do
        def self.method_added(name)
          $methods_added << name
        end
        
        def test() end
        def test2() end
        def test() end
      end
      
      $methods_added.should_equal([:test,:test2, :test] )
    ensure
      $methods_added = nil
    end
  end
end
