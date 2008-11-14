# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Module#include" do |it| 
  it.calls " #append_features(self) in reversed order on each module" do
    $appended_modules = []

    m = Module.new do
      def self.append_features(mod)
        $appended_modules << [ self, mod ]
      end
    end

    m2 = Module.new do
      def self.append_features(mod)
        $appended_modules << [ self, mod ]
      end
    end

    m3 = Module.new do
      def self.append_features(mod)
        $appended_modules << [ self, mod ]
      end
    end

    c = Class.new { include(m, m2, m3) }

    $appended_modules.should_equal([ [ m3, c], [ m2, c ], [ m, c ] ])
  end

  it.will "add all ancestor modules when a previously included module is included again" do
    ModuleSpecs::MultipleIncludes.ancestors.should_include(ModuleSpecs::MA, ModuleSpecs::MB)
    ModuleSpecs::MB.send(:include, ModuleSpecs::MC)
    ModuleSpecs::MultipleIncludes.send(:include, ModuleSpecs::MB)
    ModuleSpecs::MultipleIncludes.ancestors.should_include(ModuleSpecs::MA, ModuleSpecs::MB, ModuleSpecs::MC)
  end

  it.raises " a TypeError when the argument is not a Module" do
    lambda { ModuleSpecs::Basic.send(:include, Class.new) }.should_raise(TypeError)
  end

  it.does_not "raise a TypeError when the argument is an instance of a subclass of Module" do
    lambda { ModuleSpecs::SubclassSpec.send(:include, ModuleSpecs::Subclass.new) }.should_not raise_error(TypeError)
  end

  it.will "import constants to modules and classes" do
    ModuleSpecs::A.constants.should_include("CONSTANT_A")
    ModuleSpecs::B.constants.should_include("CONSTANT_A","CONSTANT_B")
    ModuleSpecs::C.constants.should_include("CONSTANT_A","CONSTANT_B")
  end

  it.does_not "override existing constants in modules and classes" do
    ModuleSpecs::A::OVERRIDE.should_equal(:a)
    ModuleSpecs::B::OVERRIDE.should_equal(:b)
    ModuleSpecs::C::OVERRIDE.should_equal(:c)
  end

  it.will "import instance methods to modules and classes" do
    ModuleSpecs::A.instance_methods.should_include("ma")
    ModuleSpecs::B.instance_methods.should_include("ma","mb")
    ModuleSpecs::C.instance_methods.should_include("ma","mb")
  end

  it.will "imports constants to the toplevel" do
    eval "include ModuleSpecs::Z", TOPLEVEL_BINDING
    MODULE_SPEC_TOPLEVEL_CONSTANT.should_equal(1)
  end

  it.does_not "import methods to modules and classes" do
    ModuleSpecs::A.methods.include?("cma").should_equal(true)
    ModuleSpecs::B.methods.include?("cma").should_equal(false)
    ModuleSpecs::B.methods.include?("cmb").should_equal(true)
    ModuleSpecs::C.methods.include?("cma").should_equal(false)
    ModuleSpecs::C.methods.include?("cmb").should_equal(false)
  end

  it.will "attache the module as the caller's immediate ancestor" do
    module IncludeSpecsTop
      def value; 5; end
    end

    module IncludeSpecsMiddle
      include IncludeSpecsTop
      def value; 6; end
    end

    class IncludeSpecsClass
      include IncludeSpecsMiddle
    end

    IncludeSpecsClass.new.value.should_equal(6)
  end

  it.will "detect cyclic includes" do
    lambda {
      module ModuleSpecs::M
        include ModuleSpecs::M
      end
    }.should_raise(ArgumentError)
  end
end

describe "Module#include?" do |it| 
  it.returns "true if the given module is included by self or one of it's ancestors" do
    ModuleSpecs::Super.include?(ModuleSpecs::Basic).should_equal(true)
    ModuleSpecs::Child.include?(ModuleSpecs::Basic).should_equal(true)
    ModuleSpecs::Child.include?(ModuleSpecs::Super).should_equal(true)
    ModuleSpecs::Child.include?(Kernel).should_equal(true)

    ModuleSpecs::Parent.include?(ModuleSpecs::Basic).should_equal(false)
    ModuleSpecs::Basic.include?(ModuleSpecs::Super).should_equal(false)
  end

  it.raises " a TypeError when no module was given" do
    lambda { ModuleSpecs::Child.include?("Test") }.should_raise(TypeError)
    lambda { ModuleSpecs::Child.include?(ModuleSpecs::Parent) }.should_raise(TypeError)
  end
end
