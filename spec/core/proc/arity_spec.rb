# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Proc#arity" do |it| 
  it.returns "the number of arguments, using Proc.new" do
    Proc.new { || }.arity.should_equal(0)
    Proc.new { |a| }.arity.should_equal(1)
    Proc.new { |_| }.arity.should_equal(1)
    Proc.new { |a, b| }.arity.should_equal(2)
    Proc.new { |a, b, c| }.arity.should_equal(3)
  end
  
  it.returns "the number of arguments, using Kernel#lambda" do
    lambda { || }.arity.should_equal(0)
    lambda { |a| }.arity.should_equal(1)
    lambda { |_| }.arity.should_equal(1)
    lambda { |a, b| }.arity.should_equal(2)
    lambda { |a, b, c| }.arity.should_equal(3)
  end
  
  it.returns " the number of arguments, using Kernel#proc" do
    proc { || }.arity.should_equal(0)
    proc { |a| }.arity.should_equal(1)
    proc { |_| }.arity.should_equal(1)
    proc { |a, b| }.arity.should_equal(2)
    proc { |a, b, c| }.arity.should_equal(3)
  end
  
  it.can "if optional arguments, return the negative number of mandatory arguments using Proc.new " do
    Proc.new { |*a| }.arity.should_equal(-1)
    Proc.new { |a, *b| }.arity.should_equal(-2)
    Proc.new { |a, b, *c| }.arity.should_equal(-3)
  end
  
  it.can "if optional arguments, return the negative number of mandatory arguments using Kernel#lambda" do
    lambda { |*a| }.arity.should_equal(-1)
    lambda { |a, *b| }.arity.should_equal(-2)
    lambda { |a, b, *c| }.arity.should_equal(-3)
  end
  
  it.can "if optional arguments, return the negative number of mandatory arguments using Kernel#proc" do
    proc { |*a| }.arity.should_equal(-1)
    proc { |a, *b| }.arity.should_equal(-2)
    proc { |a, b, *c| }.arity.should_equal(-3)
  end
  
  it.returns "-1 if no argument declaration is made, using Proc.new" do
    Proc.new { }.arity.should_equal(-1)
  end
  
  it.returns "-1 if no argument declaration is made, using Kernel#lambda" do
    lambda { }.arity.should_equal(-1)
  end
  
  it.returns "-1 if no argument declaration is made, using Kernel#proc" do
    proc { }.arity.should_equal(-1)
  end
end
