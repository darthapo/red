# require File.dirname(__FILE__) + '/../spec_helper'

describe "The unless expression" do |it| 
  it.can "evaluates the unless body when the expression is false" do
    unless false
      a = true
    else
      a = false
    end
    
    a.should_equal(true)
  end
  
  it.returns "the last statement in the body" do
    unless false
      'foo'
      'bar'
      'baz'
    end.should_equal('baz')
  end
  
  it.can "evaluates the else body when the expression is true" do
    unless true
      'foo'
    else
      'bar'
    end.should_equal('bar')
  end
  
  it.can "take an optional then after the expression" do
    unless false then
      'baz'
    end.should_equal('baz')
  end
  
  it.does_not "return a value when the expression is true" do
    unless true; end.should_equal(nil)
  end

  it.can "allows expression and body to be on one line (using ':')" do
    unless false: 'foo'; else 'bar'; end.should_equal('foo')
  end
  
  it.can "allows expression and body to be on one line (using 'then')" do
    unless false then 'foo'; else 'bar'; end.should_equal('foo')
  end
end