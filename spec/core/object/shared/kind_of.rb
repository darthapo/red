module ObjectSpecs
  module SomeOtherModule; end
  module AncestorModule; end
  module MyModule; end
  module MyExtensionModule; end

  class AncestorClass < String 
    include AncestorModule 
  end

  class KindaClass < AncestorClass
    include MyModule
    def initialize
      self.extend MyExtensionModule
    end
  end
end

describe :object_kind_of, :shared => true do
  before(:each) do
    @o = ObjectSpecs::KindaClass.new
  end

  it.returns "true if given class is the object's class" do
    @o.send(@method, ObjectSpecs::KindaClass).should_equal(true)
  end

  it.returns "true if given class is an ancestor of the object's class" do
    @o.send(@method, ObjectSpecs::AncestorClass).should_equal(true)
    @o.send(@method, String).should_equal(true)
    @o.send(@method, Object).should_equal(true)
  end

  it.returns "false if the given class is not object's class nor an ancestor" do
    @o.send(@method, Array).should_equal(false)
  end

  it.returns "true if given a Module that is included in object's class" do
    @o.send(@method, ObjectSpecs::MyModule).should_equal(true)
  end

  it.returns "true if given a Module that is included one of object's ancestors only" do
    @o.send(@method, ObjectSpecs::AncestorModule).should_equal(true)
  end
  
  it.returns "true if given a Module that object has been extended with" do
    @o.send(@method, ObjectSpecs::MyExtensionModule).should_equal(true)
  end

  it.returns "false if given a Module not included in object's class nor ancestors" do
    @o.send(@method, ObjectSpecs::SomeOtherModule).should_equal(false)
  end

  it.raises " a TypeError if given an object that is not a Class nor a Module" do
    lambda { @o.send(@method, 1) }.should_raise(TypeError)
    lambda { @o.send(@method, 'KindaClass') }.should_raise(TypeError)
    lambda { @o.send(@method, :KindaClass) }.should_raise(TypeError)
    lambda { @o.send(@method, Object.new) }.should_raise(TypeError)
  end
end
