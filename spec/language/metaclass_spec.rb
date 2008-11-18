# require File.dirname(__FILE__) + '/../spec_helper'
# require File.dirname(__FILE__) + '/../fixtures/class'

describe "self in a metaclass body (class << obj)" do |it| 
  it.is "TrueClass for true" do
    class << true; self; end.should_equal(TrueClass)
  end

  it.is "FalseClass for false" do
    class << false; self; end.should_equal(FalseClass)
  end

  it.is "NilClass for nil" do
    class << nil; self; end.should_equal(NilClass)
  end

  it.raises " a TypeError for numbers" do
    lambda { class << 1; self; end }.should_raise(TypeError)
  end

  it.raises " a TypeError for symbols" do
    lambda { class << :symbol; self; end }.should_raise(TypeError)
  end

  it.is_a " singleton Class instance" do
    cls = class << mock('x'); self; end
    cls.is_a?(Class).should_equal(true)
    cls.should_not equal(Object)
  end
  
  deviates_on(:rubinius) do 
    it.is_a " MetaClass instance" do
      cls = class << mock('x'); self; end
      cls.is_a?(MetaClass).should_equal(true)
    end

    it.can "has the object's class as superclass" do
      cls = class << "blah"; self; end
      cls.superclass.should_equal(String)
    end
  end
end

describe "A constant on a metaclass" do |it| 
  it.before(:each) do
    @object = Object.new
    class << @object
      CONST = self
    end
  end

  it.can "can be accessed after the metaclass body is reopened" do
    class << @object
      CONST.should_equal(self)
    end
  end

  it.can "can be accessed via self::CONST" do
    class << @object
      self::CONST.should_equal(self)
    end
  end

  it.can "can be accessed via const_get" do
    class << @object
      const_get(:CONST).should_equal(self)
    end
  end

  it.is_not " defined on the object's class" do
    @object.class.const_defined?(:CONST).should_be_false
  end

  it.is_not " defined in the metaclass opener's scope" do
    class << @object
      CONST
    end
    lambda { CONST }.should_raise(NameError)
  end

  it.can "cannot be accessed via object::CONST" do
    lambda do
      @object::CONST
    end.should_raise(TypeError)
  end

  it.raises " a NameError for anonymous_module::CONST" do
    @object = Class.new
    class << @object
      CONST = 100
    end
    
    lambda do
      @object::CONST
    end.should_raise(NameError)
  end

  it.can "appears in the metaclass constant list" do
    constants = class << @object; constants; end 
    constants.should_include("CONST")
  end

  it.does_not "appear in the object's class constant list" do
    @object.class.constants.should_not include("CONST")
  end

  it.is_not " preserved when the object is duped" do
    @object = @object.dup

    lambda do
      class << @object; CONST; end
    end.should_raise(NameError)
  end

  it.is "preserved when the object is cloned" do
    @object = @object.clone

    class << @object
      CONST.should_not be_nil
    end
  end
end




