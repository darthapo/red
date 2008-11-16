# require File.dirname(__FILE__) + '/../spec_helper'

describe "The || statement" do |it| 
  it.can "evaluates to true if any of its operands are true" do
    if false || true || nil
      x = true
    end
    x.should_equal(true)
  end
  
  it.can "evaluated to false if all of its operands are false" do
    if false || nil
      x = true
    end
    x.should_equal(nil)
  end
  
  it.is "evaluated before assignment operators" do
    x = nil || true
    x.should_equal(true)
  end
  
  it.can "has a lower precedence than the && operator" do
    x = 1 || false && x = 2
    x.should_equal(1)
  end

  it.can "treats empty expressions as nil" do
    (() || true).should_be_true
    (() || false).should_be_false
    (true || ()).should_be_true
    (false || ()).should_be_nil
    (() || ()).should_be_nil
  end
end

describe "The or statement" do |it| 
  it.can "evaluates to true if any of its operands are true" do
    x = nil
    if false or true
      x = true
    end
    x.should_equal(true)
  end
  
  it.is "evaluated after variables are assigned" do
    x = nil or true
    x.should_equal(nil)
  end

  it.can "has a lower precedence than the || operator" do
    x,y = nil
    x = true || false or y = 1
    y.should_equal(nil)
  end

  it.can "treats empty expressions as nil" do
    (() or true).should_be_true
    (() or false).should_be_false
    (true or ()).should_be_true
    (false or ()).should_be_nil
    (() or ()).should_be_nil
  end
end
