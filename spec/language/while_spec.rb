# require File.dirname(__FILE__) + '/../spec_helper'

# while bool-expr [do]
#   body
# end
#
# begin
#   body
# end while bool-expr
#
# expr while bool-expr
describe "The while expression" do |it| 
  it.can "runs while the expression is true" do
    i = 0
    while i < 3
      i += 1
    end
    i.should_equal(3)
  end
  
  it.can "optionally takes a 'do' after the expression" do
    i = 0
    while i < 3 do
      i += 1
    end
    
    i.should_equal(3)
  end
  
  it.can "allows body begin on the same line if do is used" do
    i = 0
    while i < 3 do i += 1
    end
    
    i.should_equal(3)
  end
  
  it.can "executes code in containing variable scope" do
    i = 0
    while i != 1
      a = 123
      i = 1
    end
    
    a.should_equal(123)
  end
  
  it.can "executes code in containing variable scope with 'do'" do
    i = 0
    while i != 1 do
      a = 123
      i = 1
    end
    
    a.should_equal(123)
  end
  
  it.returns "nil if ended when condition became false" do
    i = 0
    while i < 3
      i += 1
    end.should_equal(nil)
  end

  it.does_not "evaluate the body if expression is empty" do
    a = []
    while ()
      a << :body_evaluated
    end
    a.should_equal([])
  end

  it.can "stops running body if interrupted by break" do
    i = 0
    while i < 10
      i += 1
      break if i > 5
    end
    i.should_equal(6)
  end
  
  it.returns "value passed to break if interrupted by break" do
    while true
      break 123
    end.should_equal(123)
  end
  
  it.returns "nil if interrupted by break with no arguments" do
    while true
      break
    end.should_equal(nil)
  end

  it.can "skips to end of body with next" do
    a = []
    i = 0
    while (i+=1)<5
      next if i==3
      a << i
    end
    a.should_equal([1, 2, 4])
  end

  it.can "restarts the current iteration without reevaluating condition with redo" do
    a = []
    i = 0
    j = 0
    while (i+=1)<3
      a << i
      j+=1
      redo if j<3
    end
    a.should_equal([1, 1, 1, 2])
  end
end
  
describe "The while modifier" do |it| 
  it.can "runs preceding statement while the condition is true" do
    i = 0
    i += 1 while i < 3
    i.should_equal(3)
  end
  
  it.can "evaluates condition before statement execution" do
    a = []
    i = 0
    a << i while (i+=1) < 3
    a.should_equal([1, 2])
  end
  
  it.does_not "run preceding statement if the condition is false" do
    i = 0
    i += 1 while false
    i.should_equal(0)
  end

  it.does_not "run preceding statement if the condition is empty" do
    i = 0
    i += 1 while ()
    i.should_equal(0)
  end

  it.returns "nil if ended when condition became false" do
    i = 0
    (i += 1 while i<10).should_equal(nil)
  end
  
  it.returns "value passed to break if interrupted by break" do
    (break 123 while true).should_equal(123)
  end
  
  it.returns "nil if interrupted by break with no arguments" do
    (break while true).should_equal(nil)
  end

  it.can "skips to end of body with next" do
    i = 0
    j = 0
    ((i+=1) == 3 ? next : j+=i) while i <= 10
    j.should_equal(63)
  end

  it.can "restarts the current iteration without reevaluating condition with redo" do
    i = 0
    j = 0
    (i+=1) == 4 ? redo : j+=i while (i+=1) <= 10
    j.should_equal(34)
  end
end

describe "The while modifier with begin .. end block" do |it| 
  it.can "runs block while the expression is true" do
    i = 0
    begin
      i += 1
    end while i < 3
    
    i.should_equal(3)
  end
  
  it.can "stops running block if interrupted by break" do
    i = 0
    begin
      i += 1
      break if i > 5
    end while i < 10
    
    i.should_equal(6)
  end
  
  it.returns "value passed to break if interrupted by break" do
    (begin; break 123; end while true).should_equal(123)
  end
  
  it.returns "nil if interrupted by break with no arguments" do
    (begin; break; end while true).should_equal(nil)
  end
  
  it.can "runs block at least once (even if the expression is false)" do
    i = 0
    begin
      i += 1
    end while false
    
    i.should_equal(1)
  end

  it.can "evaluates condition after block execution" do
    a = []
    i = 0
    begin
      a << i
    end while (i+=1)<5
    a.should_equal([0, 1, 2, 3, 4])
  end

  it.can "skips to end of body with next" do
    a = []
    i = 0
    begin
      next if i==3
      a << i
    end while (i+=1)<5
    a.should_equal([0, 1, 2, 4])
  end

  it.can "restarts the current iteration without reevaluting condition with redo" do
    a = []
    i = 0
    j = 0
    begin
      a << i
      j+=1
      redo if j<3
    end while (i+=1)<3
    a.should_equal([0, 0, 0, 1, 2])
  end
end
