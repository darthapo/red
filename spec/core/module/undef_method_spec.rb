# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

module ModuleSpecs
  class NoInheritance
    def method_to_undef() 1 end
    def another_method_to_undef() 1 end
  end

  class Parent
    def method_to_undef() 1 end
    def another_method_to_undef() 1 end
  end

  class Child < Parent
  end

  class Ancestor
    def method_to_undef() 1 end
    def another_method_to_undef() 1 end
  end

  class Descendant < Ancestor
  end
end

describe "Module#undef_method with symbol" do |it| 
  it.can "remove a method defined in a class" do
    x = ModuleSpecs::NoInheritance.new

    x.method_to_undef.should_equal(1)

    ModuleSpecs::NoInheritance.send :undef_method, :method_to_undef

    lambda { x.method_to_undef }.should_raise(NoMethodError)
  end

  it.can "remove a method defined in a super class" do
    child = ModuleSpecs::Child.new
    child.method_to_undef.should_equal(1)

    ModuleSpecs::Child.send :undef_method, :method_to_undef

    lambda { child.method_to_undef }.should_raise(NoMethodError)
  end

  it.does_not "remove a method defined in a super class when removed from a subclass" do
    ancestor = ModuleSpecs::Ancestor.new
    ancestor.method_to_undef.should_equal(1)

    ModuleSpecs::Descendant.send :undef_method, :method_to_undef

    ancestor.method_to_undef.should_equal(1)
  end
end

describe "Module#undef_method with string" do |it| 
  it.can "remove a method defined in a class" do
    x = ModuleSpecs::NoInheritance.new

    x.another_method_to_undef.should_equal(1)

    ModuleSpecs::NoInheritance.send :undef_method, 'another_method_to_undef'

    lambda { x.another_method_to_undef }.should_raise(NoMethodError)
  end

  it.can "remove a method defined in a super class" do
    child = ModuleSpecs::Child.new
    child.another_method_to_undef.should_equal(1)

    ModuleSpecs::Child.send :undef_method, 'another_method_to_undef'

    lambda { child.another_method_to_undef }.should_raise(NoMethodError)
  end

  it.does_not "remove a method defined in a super class when removed from a subclass" do
    ancestor = ModuleSpecs::Ancestor.new
    ancestor.another_method_to_undef.should_equal(1)

    ModuleSpecs::Descendant.send :undef_method, 'another_method_to_undef'

    ancestor.another_method_to_undef.should_equal(1)
  end
end
