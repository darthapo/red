# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Module#class_variable_get" do |it| 
  it.returns "the value of the class variable with the given name" do
    c = Class.new { class_variable_set :@@class_var, "test" }
    c.send(:class_variable_get, :@@class_var).should_equal("test")
    c.send(:class_variable_get, "@@class_var").should_equal("test")
  end

  it.returns "the value of a class variable with the given name defined in an included module" do
    c = Class.new { include ModuleSpecs::MVars }
    c.send(:class_variable_get, "@@mvar").should_equal(:mvar)
  end

  it.raises " a NameError for a class variables with the given name defined in an extended module" do
    c = Class.new
    c.extend ModuleSpecs::MVars
    lambda {
      c.send(:class_variable_get, "@@mvar")
    }.should_raise(NameError)
  end

  it.returns "class variables defined in the class body and accessed in the metaclass" do
    ModuleSpecs::CVars.cls.should_equal(:class)
  end

  it.returns "class variables defined in the metaclass and accessed by class methods" do
    ModuleSpecs::CVars.meta.should_equal(:meta)
  end

  it.returns "class variables defined in the metaclass and accessed by instance methods" do
    ModuleSpecs::CVars.new.meta.should_equal(:meta)
  end

  not_compliant_on :rubinius do
    it.will "accept Fixnums for class variables" do
      c = Class.new { class_variable_set :@@class_var, "test" }
      c.send(:class_variable_get, :@@class_var.to_i).should_equal("test")
    end

    it.raises " a NameError when a Fixnum for an uninitialized class variable is given" do
      c = Class.new
      lambda {
        c.send :class_variable_get, :@@no_class_var.to_i
      }.should_raise(NameError)
    end
  end

  it.raises " a NameError when an uninitialized class variable is accessed" do
    c = Class.new
    [:@@no_class_var, "@@no_class_var"].each do |cvar|
      lambda  { c.send(:class_variable_get, cvar) }.should_raise(NameError)
    end
  end

  it.raises " a NameError when the given name is not allowed" do
    c = Class.new

    lambda { c.send(:class_variable_get, :invalid_name)   }.should_raise(NameError)
    lambda { c.send(:class_variable_get, "@invalid_name") }.should_raise(NameError)
  end

  it.can "convert a non string/symbol/fixnum name to string using to_str" do
    c = Class.new { class_variable_set :@@class_var, "test" }
    (o = mock('@@class_var')).should_receive(:to_str).and_return("@@class_var")
    c.send(:class_variable_get, o).should_equal("test")
  end

  it.raises " a TypeError when the given names can't be converted to strings using to_str" do
    c = Class.new { class_variable_set :@@class_var, "test" }
    o = mock('123')
    lambda { c.send(:class_variable_get, o) }.should_raise(TypeError)
    o.should_receive(:to_str).and_return(123)
    lambda { c.send(:class_variable_get, o) }.should_raise(TypeError)
  end
end
