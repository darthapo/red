# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Class.new with a block given" do |it| 
  it.can "uses the given block as the class' body" do
    klass = Class.new do
      def self.message
        "text"
      end

      def hello
        "hello again"
      end
    end

    klass.message.should     == "text"
    klass.new.hello.should_equal("hello again")
  end

  it.creates "a subclass of the given superclass" do
    sc = Class.new do
      def self.body
        @body
      end
      @body = self
      def message; "text"; end
    end
    klass = Class.new(sc) do
      def self.body
        @body
      end
      @body = self
      def message2; "hello"; end
    end

    klass.body.should_equal(klass)
    sc.body.should_equal(sc)
    klass.superclass.should_equal(sc)
    klass.new.message.should_equal("text")
    klass.new.message2.should_equal("hello")
    klass.dup.body.should_equal(klass)
  end
end

describe "Class.new" do |it| 
  it.creates "a new anonymous class" do
    klass = Class.new
    klass.is_a?(Class).should_equal(true)

    klass_instance = klass.new
    klass_instance.is_a?(klass).should_equal(true)
  end

  it.creates "a class without a name" do
    Class.new.name.should_equal("")
  end

  it.creates "a class that can be given a name by assigning it to a constant" do
    MyClass = Class.new
    MyClass.name.should_equal("MyClass")
    a = Class.new
    MyClass::NestedClass = a
    MyClass::NestedClass.name.should_equal("MyClass::NestedClass")
  end

  it.will "set the new class' superclass to the given class" do
    top = Class.new
    Class.new(top).superclass.should_equal(top)
  end

  it.will "set the new class' superclass to Object when no class given" do
    Class.new.superclass.should_equal(Object)
  end

  it.raises " a TypeError when given a non-Class" do
    error_msg = /superclass must be a Class/
    lambda { Class.new("")         }.should_raise(TypeError, error_msg)
    lambda { Class.new(1)          }.should_raise(TypeError, error_msg)
    lambda { Class.new(:symbol)    }.should_raise(TypeError, error_msg)
    lambda { Class.new(mock('o'))  }.should_raise(TypeError, error_msg)
    lambda { Class.new(Module.new) }.should_raise(TypeError, error_msg)
  end
end
