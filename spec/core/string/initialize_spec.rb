# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#initialize" do |it| 
  it.is_a " private method" do
    "".private_methods.should_include("initialize")
  end
  
  it.will "replace contents of self with the passed string" do
    s = "some string"
    id = s.object_id
    s.send :initialize, "another string"
    s.should_equal("another string")
    s.object_id.should_equal(id)
  end
  
  it.does_not "change self when not passed a string" do
    s = "some string"
    s.send :initialize
    s.should_equal("some string")
  end
  
  it.will "replace the taint status of self with that of the passed string" do
    a = "an untainted string"
    b = "a tainted string".taint
    a.send :initialize, b
    a.tainted?.should_equal(true)
  end
  
  it.returns "an instance of a subclass" do
    a = StringSpecs::MyString.new("blah")
    a.should_be_kind_of(StringSpecs::MyString)
    a.should_equal("blah")
  end
  
  it.is "called on subclasses" do
    s = StringSpecs::SubString.new
    s.special.should_equal(nil)
    s.should_equal("")
    
    s = StringSpecs::SubString.new "subclass"
    s.special.should_equal("subclass")
    s.should_equal("")
  end

  it.can "convert its argument to a string representation" do
    obj = mock 'foo'
    obj.should_receive(:to_str).and_return('foo')

    String.new obj
  end
  
  # Rubinius String makes a String of 5 NULs.  This behavior may need to be
  # removed from many places.
  it.raises " TypeError on inconvertible object" do
    lambda { String.new 5 }.should_raise(TypeError)
  end
  
  compliant_on :ruby, :jruby do
    it.raises " a TypeError if self is frozen" do
      a = "hello".freeze

      a.send :initialize, a
      lambda { a.send :initialize, "world" }.should_raise(TypeError)
    end
  end
end
