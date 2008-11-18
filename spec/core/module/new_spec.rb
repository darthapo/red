# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Module.new" do |it| 
  it.creates "a new anonymous Module" do
    Module.new.is_a?(Module).should_equal(true)
  end

  it.creates "a new Module and passes it to the provided block" do
    test_mod = nil
    m = Module.new do |mod|
      mod.should_not == nil
      self.should_equal(mod)
      test_mod = mod
      mod.is_a?(Module).should_equal(true)
      Object.new # trying to return something
    end
    test_mod.should_equal(m)
  end

  it.will "evaluate a passed block in the context of the module" do
    fred = Module.new do
      def hello() "hello" end
      def bye()   "bye"   end
    end
    
    (o = mock('x')).extend(fred)
    o.hello.should_equal("hello")
    o.bye.should   == "bye"
  end
end
