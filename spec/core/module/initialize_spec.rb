# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Module#initialize" do |it| 
  it.will "accept a block" do
    m = Module.new do
      const_set :A, "A"
    end
    m.const_get("A").should_equal("A")
  end
  
  it.is "called on subclasses" do
    m = ModuleSpecs::SubModule.new
    m.special.should_equal(10)
    m.methods.should_not == nil
    m.constants.should_not == nil
  end
end
