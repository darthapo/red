# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Module#private_class_method" do |it| 
  before(:each) do
    # This is not in classes.rb because after marking a class method private it 
    # will stay private.
    class << ModuleSpecs::Parent
      def private_method_1; end
      def private_method_2; end
      def private_method_3; end
    end
  end

  it.will "make an existing class method private" do
    ModuleSpecs::Parent.private_method_1.should_equal(nil)
    ModuleSpecs::Parent.private_class_method :private_method_1
    lambda { ModuleSpecs::Parent.private_method_1  }.should_raise(NoMethodError)

    # Technically above we're testing the Singleton classes, class method(right?).
    # Try a "real" class method set private.
    lambda { ModuleSpecs::Parent.private_method }.should_raise(NoMethodError)
  end

  it.will "make an existing class method private up the inheritance tree" do
    ModuleSpecs::Child.private_method_1.should_equal(nil)
    ModuleSpecs::Child.private_class_method :private_method_1

    lambda { ModuleSpecs::Child.private_method_1 }.should_raise(NoMethodError)
    lambda { ModuleSpecs::Child.private_method   }.should_raise(NoMethodError)
  end

  it.will "accept more than one method at a time" do
    ModuleSpecs::Parent.private_method_1.should_equal(nil)
    ModuleSpecs::Parent.private_method_2.should_equal(nil)
    ModuleSpecs::Parent.private_method_3.should_equal(nil)

    ModuleSpecs::Child.private_class_method :private_method_1, :private_method_2, :private_method_3
    
    lambda { ModuleSpecs::Child.private_method_1 }.should_raise(NoMethodError)
    lambda { ModuleSpecs::Child.private_method_2 }.should_raise(NoMethodError)
    lambda { ModuleSpecs::Child.private_method_3 }.should_raise(NoMethodError)
  end

  it.raises " a NameError if class method doesn't exist" do
    lambda { ModuleSpecs.private_class_method :no_method_here }.should_raise(NameError)
  end

  it.can "make a class method private" do
    c = Class.new do
      def self.foo() "foo" end
      private_class_method :foo
    end
    lambda { c.foo }.should_raise(NoMethodError)
  end

  it.raises " a NameError when the given name is not a method" do
    lambda {
      c = Class.new do
        private_class_method :foo
      end
    }.should_raise(NameError)
  end

  it.raises " a NameError when the given name is an instance method" do
    lambda {
      c = Class.new do
        def foo() "foo" end
        private_class_method :foo
      end
    }.should_raise(NameError)
  end
end
