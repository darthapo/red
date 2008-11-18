# require File.dirname(__FILE__) + '/../spec_helper'

describe "The '&&' statement" do |it| 
  
  it.will "short-circuit evaluation at the first condition to be false" do
    x = nil
    true && false && x = 1
    x.should_be_nil
  end
  
  it.will "evalute to the first condition not to be true" do
    ("yes" && 1 && nil && true).should_equal(nil)
    ("yes" && 1 && false && true).should_equal(false)
  end
  
  it.will "evalute to the last condition if all are true" do
    ("yes" && 1).should_equal(1)
    (1 && "yes").should_equal("yes")
  end
  
  it.will "evaluate the full set of chained conditions during assignment" do
    x, y = nil
    x = 1 && y = 2
    # "1 && y = 2" is evaluated and then assigned to x
    x.should_equal(2)
  end

  it.will "treat empty expressions as nil" do
    (() && true).should_be_nil
    (true && ()).should_be_nil
    (() && ()).should_be_nil
  end

end

describe "The 'and' statement" do |it| 
  it.will "short-circuit evaluation at the first condition to be false" do
    x = nil
    true and false and x = 1
    x.should_be_nil
  end
  
  it.will "evalute to the first condition not to be true" do
    ("yes" and 1 and nil and true).should_equal(nil)
    ("yes" and 1 and false and true).should_equal(false)
  end
  
  it.will "evalute to the last condition if all are true" do
    ("yes" and 1).should_equal(1)
    (1 and "yes").should_equal("yes")
  end
  
  it.will "when used in assignment, evaluates and assigns expressions individually" do
    x, y = nil
    x = 1 and y = 2
    # evaluates (x=1) and (y=2)
    x.should_equal(1)
  end

  it.will "treats empty expressions as nil" do
    (() and true).should_be_nil
    (true and ()).should_be_nil
    (() and ()).should_be_nil
  end
end
