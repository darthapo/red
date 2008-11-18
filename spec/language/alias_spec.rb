# require File.dirname(__FILE__) + '/../spec_helper'

class AliasObject
  attr :foo
  attr_reader :bar
  attr_accessor :baz
  
  def prep; @foo = 3; @bar = 4; end
  def value; 5; end
  def false_value; 6; end
end

describe "The alias keyword" do |it| 
  it.before(:each) do
    @obj = AliasObject.new
    @meta = class << @obj;self;end
  end

  it.creates "a new name for an existing method" do
    @meta.class_eval do
      alias __value value
    end
    @obj.__value.should_equal(5)
  end

  it.will "add the new method to the list of methods" do
    original_methods = @obj.methods
    @meta.class_eval do
      alias __value value
    end
    (@obj.methods - original_methods).should_equal(["__value"])
  end

  it.will "add the new method to the list of public methods" do
    original_methods = @obj.public_methods
    @meta.class_eval do
      alias __value value
    end
    (@obj.public_methods - original_methods).should_equal(["__value"])
  end

  it.will "overwrite an existing method with the target name" do
    @meta.class_eval do
      alias false_value value
    end
    @obj.false_value.should_equal(5)
  end

  it.is "reversible" do
    @meta.class_eval do
      alias __value value
      alias value false_value
    end
    @obj.value.should_equal(6)

    @meta.class_eval do
      alias value __value
    end
    @obj.value.should_equal(5)
  end

  it.will "operate on the object's metaclass when used in instance_eval" do
    @obj.instance_eval do
      alias __value value
    end

    @obj.__value.should_equal(5)
    lambda { AliasObject.new.__value }.should_raise(NoMethodError)
  end

  it.will "operate on methods defined via attr, attr_reader, and attr_accessor" do
    @obj.prep
    @obj.instance_eval do
      alias afoo foo
      alias abar bar
      alias abaz baz
    end

    @obj.afoo.should_equal(3)
    @obj.abar.should_equal(4)
    @obj.baz = 5
    @obj.abaz.should_equal(5)
  end
end
