# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Integer#times" do |it| 
  it.returns "self" do
    5.times {}.should_equal(5)
    9.times {}.should_equal(9)
    9.times { |n| n - 2 }.should_equal(9)
  end
  
  it.yields "each value from 0 to self - 1" do
    a = []
    9.times { |i| a << i }
    -2.times { |i| a << i }
    a.should_equal([0, 1, 2, 3, 4, 5, 6, 7, 8])
  end
  
  it.can "skip the current iteration when encountering 'next'" do
    a = []
    3.times do |i|
      next if i == 1
      a << i
    end
    a.should_equal([0, 2])
  end
  
  it.can "skip all iterations when encountering 'break'" do
    a = []
    5.times do |i|
      break if i == 3
      a << i
    end
    a.should_equal([0, 1, 2])
  end
  
  it.can "skip all iterations when encountering break with an argument and returns that argument" do
    9.times { break 2 }.should_equal(2)
  end

  it.will "execute a nested while loop containing a break expression" do
    a = [false]
    b = 1.times do |i|
      while true
        a.shift or break
      end
    end
    a.should_equal([])
    b.should_equal(1)
  end

  it.will "execute a nested #times" do
    a = 0
    b = 3.times do |i|
      2.times { a += 1 }
    end
    a.should_equal(6)
    b.should_equal(3)
  end
end