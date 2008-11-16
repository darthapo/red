# require File.dirname(__FILE__) + '/../spec_helper'

describe "The loop expression" do |it| 
  
  it.can "repeats the given block until a break is called" do
    outer_loop = 0
    loop do
      outer_loop += 1
      break if outer_loop == 10
    end
    outer_loop.should_equal(10)
  end
  
  it.can "executes code in its own scope" do
    loop do
      inner_loop = 123
      break
    end
    lambda { inner_loop }.should_raise(NameError)
  end
  
  it.returns "the value passed to break if interrupted by break" do
    loop do
      break 123
    end.should_equal(123)
  end
  
  it.returns "nil if interrupted by break with no arguments" do
    loop do
      break
    end.should_equal(nil)
  end

  it.can "skips to end of body with next" do
    a = []
    i = 0
    loop do
      break if (i+=1) >= 5
      next if i == 3
      a << i
    end
    a.should_equal([1, 2, 4])
  end
  
  it.can "restarts the current iteration with redo" do
    a = []
    loop do
      a << 1
      redo if a.size < 2
      a << 2
      break if a.size == 3      
    end
    a.should_equal([1, 1, 2])
  end

  it.can "uses a spaghetti nightmare of redo, next and break" do
    a = []
    loop do
      a << 1
      redo if a.size == 1
      a << 2
      next if a.size == 3
      a << 3
      break if a.size > 6
    end
    a.should_equal([1, 1, 2, 1, 2, 3, 1, 2, 3])
  end  
end
