# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Array#include?" do |it| 
  it.returns "true if object is present, false otherwise" do
    [1, 2, "a", "b"].include?("c").should_equal(false)
    [1, 2, "a", "b"].include?("a").should_equal(true)
  end

  it.can "determines presence by using element == obj" do
    o = mock('')
  
    [1, 2, "a", "b"].include?(o).should_equal(false)

    def o.==(other); other == 'a'; end

    [1, 2, o, "b"].include?('a').should_equal(true)

    [1, 2.0, 3].include?(2).should_equal(true)
  end

  it.calls " == on elements from left to right until success" do
    key = "x"
    one = mock('one')
    two = mock('two')
    three = mock('three')
    one.should_receive(:==).any_number_of_times.and_return(false)
    two.should_receive(:==).any_number_of_times.and_return(true)
    three.should_not_receive(:==)
    ary = [one, two, three]
    ary.include?(key).should_equal(true)
  end
end
