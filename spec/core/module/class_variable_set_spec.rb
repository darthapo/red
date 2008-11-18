# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Module#class_variable_set" do |it| 
  it.will "set the class variable with the given name to the given value" do
    c = Class.new

    c.send(:class_variable_set, :@@test, "test")
    c.send(:class_variable_set, "@@test3", "test3")

    c.send(:class_variable_get, :@@test).should_equal("test")
    c.send(:class_variable_get, :@@test3).should_equal("test3")
  end

  it.will "set the value of a class variable with the given name defined in an included module" do
    c = Class.new { include ModuleSpecs::MVars }
    c.send(:class_variable_set, "@@mvar", :new_mvar).should_equal(:new_mvar)
    c.send(:class_variable_get, "@@mvar").should_equal(:new_mvar)
  end

  it.raises " a NameError when the given name is not allowed" do
    c = Class.new

    lambda { c.send(:class_variable_set, :invalid_name, "test")    }.should_raise(NameError)
    lambda {  c.send(:class_variable_set, "@invalid_name", "test") }.should_raise(NameError)
  end

  it.can "convert a non string/symbol/fixnum name to string using to_str" do
    (o = mock('@@class_var')).should_receive(:to_str).and_return("@@class_var")
    c = Class.new
    c.send(:class_variable_set, o, "test")
    c.send(:class_variable_get, :@@class_var).should_equal("test")
  end

  it.raises " a TypeError when the given names can't be converted to strings using to_str" do
    c = Class.new { class_variable_set :@@class_var, "test" }
    o = mock('123')
    lambda { c.send(:class_variable_set, o, "test") }.should_raise(TypeError)
    o.should_receive(:to_str).and_return(123)
    lambda { c.send(:class_variable_set, o, "test") }.should_raise(TypeError)
  end
end
