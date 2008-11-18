# require File.dirname(__FILE__) + '/../../spec_helper'

describe "StandardError" do |it| 
  it.is_a " superclass of ArgumentError" do
    StandardError.should_be_ancestor_of(ArgumentError)
  end

  it.is_a " superclass of IOError" do
    StandardError.should_be_ancestor_of(IOError)
  end

  it.is_a " superclass of IndexError" do
    StandardError.should_be_ancestor_of(IndexError)
  end

  it.is_a " superclass of LocalJumpError" do
    StandardError.should_be_ancestor_of(LocalJumpError)
  end

  it.is_a " superclass of NameError" do
    StandardError.should_be_ancestor_of(NameError)
  end
  
  it.is_a " superclass of RangeError" do
    StandardError.should_be_ancestor_of(RangeError)
  end
  
  it.is_a " superclass of RegexpError" do
    StandardError.should_be_ancestor_of(RegexpError)
  end

  it.is_a " superclass of RuntimeError" do
    StandardError.should_be_ancestor_of(RuntimeError)
  end

  it.is_a " superclass of SecurityError" do
    StandardError.should_be_ancestor_of(SecurityError)
  end

  it.is_a " superclass of SystemCallError" do
    StandardError.should_be_ancestor_of(SystemCallError.new("").class)
  end
  it.is_a " superclass of ThreadError" do
    StandardError.should_be_ancestor_of(ThreadError)
  end

  it.is_a " superclass of TypeError" do
    StandardError.should_be_ancestor_of(TypeError)
  end

  it.is_a " superclass of ZeroDivisionError" do
    StandardError.should_be_ancestor_of(ZeroDivisionError)
  end
end
