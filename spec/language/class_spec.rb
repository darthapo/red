# require File.dirname(__FILE__) + '/../spec_helper'
# require File.dirname(__FILE__) + '/../fixtures/class'

ClassSpecsNumber = 12

module ClassSpecs
  Number = 12
end

describe "A class definition" do |it| 
  it.creates "a new class" do
    ClassSpecs::A.class.should_equal(Class)
    ClassSpecs::A.new.class.should_equal(ClassSpecs::A)
  end
  
  it.can "has no class variables" do
    ClassSpecs::A.class_variables.should_equal([])
  end

  it.raises " TypeError if constant given as class name exists and is not a Module" do
    lambda {
      class ClassSpecsNumber
      end
    }.should_raise(TypeError)
  end

  # test case known to be detecting bugs (JRuby, MRI 1.9)
  it.raises " TypeError if the constant qualifying the class is nil" do
    lambda {
      class nil::Foo
      end
    }.should_raise(TypeError)
  end

  it.raises " TypeError if any constant qualifying the class is not a Module" do
    lambda {
      class ClassSpecs::Number::MyClass
      end
    }.should_raise(TypeError)

    lambda {
      class ClassSpecsNumber::MyClass
      end
    }.should_raise(TypeError)
  end
  
  it.can "allows using self as the superclass iff self is a class" do
    ClassSpecs::I::J.superclass.should_equal(ClassSpecs::I)
    
    lambda {
      class ShouldNotWork < self; end
    }.should_raise(TypeError)
  end
  
#  # I do not think this is a valid spec   -- rue
#  it.can "has no class-level instance variables" do
#    ClassSpecs::A.instance_variables.should_equal([])
#  end

  it.can "allows the declaration of class variables in the body" do
    ClassSpecs::B.class_variables.should_equal(["@@cvar"])
    ClassSpecs::B.send(:class_variable_get, :@@cvar).should_equal(:cvar)
  end
  
  it.can "stores instance variables defined in the class body in the class object" do
    ClassSpecs::B.instance_variables.include?("@ivar").should_equal(true)
    ClassSpecs::B.instance_variable_get(:@ivar).should_equal(:ivar)
  end

  it.can "allows the declaration of class variables in a class method" do
    ClassSpecs::C.class_variables.should_equal([])
    ClassSpecs::C.make_class_variable
    ClassSpecs::C.class_variables.should_equal(["@@cvar"])
  end

  it.can "allows the definition of class-level instance variables in a class method" do
    ClassSpecs::C.instance_variables.include?("@civ").should_equal(false)
    ClassSpecs::C.make_class_instance_variable
    ClassSpecs::C.instance_variables.include?("@civ").should_equal(true)
  end
  
  it.can "allows the declaration of class variables in an instance method" do
    ClassSpecs::D.class_variables.should_equal([])
    ClassSpecs::D.new.make_class_variable
    ClassSpecs::D.class_variables.should_equal(["@@cvar"])
  end
  
  it.can "allows the definition of instance methods" do
    ClassSpecs::E.new.meth.should_equal(:meth)
  end
  
  it.can "allows the definition of class methods" do
    ClassSpecs::E.cmeth.should_equal(:cmeth)
  end
  
  it.can "allows the definition of class methods using class << self" do
    ClassSpecs::E.smeth.should_equal(:smeth)
  end
  
  it.can "allows the definition of Constants" do
    Object.const_defined?('CONSTANT').should_equal(false)
    ClassSpecs::E.const_defined?('CONSTANT').should_equal(true)
    ClassSpecs::E::CONSTANT.should_equal(:constant!)
  end
  
  it.returns "the value of the last statement in the body" do
    class ClassSpecs::Empty; end.should_equal(nil)
    class ClassSpecs::Twenty; 20; end.should_equal(20)
    class ClassSpecs::Plus; 10 + 20; end.should_equal(30)
    class ClassSpecs::Singleton; class << self; :singleton; end; end.should_equal(:singleton)
  end
end

describe "An outer class definition" do |it| 
  it.can "contains the inner classes" do
    ClassSpecs::Container.constants.should_include('A', 'B')
  end
end

describe "A Class Definitions extending an object" do |it| 
  it.can "allows adding methods" do
    ClassSpecs::O.smeth.should_equal(:smeth)
  end
  
  it.raises " a TypeError when trying to extend numbers" do
    lambda {
      eval <<-CODE
        class << 1
          def xyz
            self
          end
        end
      CODE
    }.should_raise(TypeError)
  end
end

describe "Reopening a class" do |it| 
  it.can "extends the previous definitions" do
    c = ClassSpecs::F.new
    c.meth.should_equal(:meth)
    c.another.should_equal(:another)
  end
  
  it.can "overwrites existing methods" do
    ClassSpecs::G.new.override.should_equal(:override)
  end
  
  it.raises " a TypeError when superclasses mismatch" do
    lambda { class ClassSpecs::A < Array; end }.should_raise(TypeError)
  end

  it.can "adds new methods to subclasses" do
    lambda { ClassSpecs::M.m }.should_raise(NoMethodError)
    class ClassSpecs::L
      def self.m
        1
      end
    end
    ClassSpecs::M.m.should_equal(1)
  end  
end

describe "class provides hooks" do |it| 
  it.calls " inherited when a class is created" do
    ClassSpecs::H.track_inherited.should_equal([ClassSpecs::K])
  end
end
