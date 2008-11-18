# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Module#public_class_method" do |it| 
  it.before(:each) do
    class << ModuleSpecs::Parent
      private
      def public_method_1; end
      def public_method_2; end
      def public_method_3; end
    end
  end

  it.can "make an existing class method public" do
    lambda { ModuleSpecs::Parent.public_method_1 }.should_raise(NoMethodError)
    ModuleSpecs::Parent.public_class_method :public_method_1
    ModuleSpecs::Parent.public_method_1.should_equal(nil)

    # Technically above we're testing the Singleton classes, class method(right?).
    # Try a "real" class method set public.
    ModuleSpecs::Parent.public_method.should_equal(nil)
  end

  it.can "make an existing class method public up the inheritance tree" do
    lambda { ModuleSpecs::Child.public_method_1 }.should_raise(NoMethodError)
    ModuleSpecs::Child.public_class_method :public_method_1

    ModuleSpecs::Child.public_method_1.should_equal(nil)
    ModuleSpecs::Child.public_method.should_equal(nil)
  end

  it.will "accept more than one method at a time" do
    lambda { ModuleSpecs::Parent.public_method_1 }.should_raise(NameError)
    lambda { ModuleSpecs::Parent.public_method_2 }.should_raise(NameError)
    lambda { ModuleSpecs::Parent.public_method_3 }.should_raise(NameError)

    ModuleSpecs::Child.public_class_method :public_method_1, :public_method_2, :public_method_3
    
    ModuleSpecs::Child.public_method_1.should_equal(nil)
    ModuleSpecs::Child.public_method_2.should_equal(nil)
    ModuleSpecs::Child.public_method_3.should_equal(nil)
  end

  it.raises " a NameError if class method doesn't exist" do
    lambda { ModuleSpecs.public_class_method :no_method_here }.should_raise(NameError)
  end

  it.can "make a class method public" do
    c = Class.new do
      def self.foo() "foo" end
      public_class_method :foo
    end

    c.foo.should_equal("foo")
  end

  it.raises " a NameError when the given name is not a method" do
    lambda {
      c = Class.new do
        public_class_method :foo
      end
    }.should_raise(NameError)
  end

  it.raises " a NameError when the given name is an instance method" do
    lambda {
      c = Class.new do
        def foo() "foo" end
        public_class_method :foo
      end
    }.should_raise(NameError)
  end
end
