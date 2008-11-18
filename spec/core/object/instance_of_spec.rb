# require File.dirname(__FILE__) + '/../../spec_helper'

module ObjectSpecs
  module SomeOtherModule; end
  module AncestorModule; end
  module MyModule; end

  class AncestorClass < String 
    include AncestorModule 
  end

  class InstanceClass < AncestorClass
    include MyModule
  end
end

describe Object, "#instance_of?" do
  it.before(:each) do
    @o = ObjectSpecs::InstanceClass.new
  end

  it.returns "true if given class is object's class" do
    @o.instance_of?(ObjectSpecs::InstanceClass).should_equal(true )
    [].instance_of?(Array).should_equal(true )
    ''.instance_of?(String).should_equal(true )
  end

  it.returns "false if given class is object's ancestor class" do
    @o.instance_of?(ObjectSpecs::AncestorClass).should_equal(false)
  end

  it.returns "false if given class is not object's class nor object's ancestor class" do
    @o.instance_of?(Array).should_equal(false)
  end

  it.returns "false if given a Module that is included in object's class" do
    @o.instance_of?(ObjectSpecs::MyModule).should_equal(false)
  end

  it.returns "false if given a Module that is included one of object's ancestors only" do
    @o.instance_of?(ObjectSpecs::AncestorModule).should_equal(false)
  end

  it.returns "false if given a Module that is not included in object's class" do
    @o.instance_of?(ObjectSpecs::SomeOtherModule).should_equal(false)
  end

  it.raises " a TypeError if given an object that is not a Class nor a Module" do
    lambda { @o.instance_of?(Object.new) }.should_raise(TypeError)
    lambda { @o.instance_of?('ObjectSpecs::InstanceClass') }.should_raise(TypeError)
    lambda { @o.instance_of?(1) }.should_raise(TypeError)
  end
end
