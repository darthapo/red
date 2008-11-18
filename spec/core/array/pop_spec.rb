# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Array#pop" do |it| 
  it.can "removes and returns the last element of the array" do
    a = ["a", 1, nil, true]
    
    a.pop.should_equal(true)
    a.should_equal(["a", 1, nil])

    a.pop.should_equal(nil)
    a.should_equal(["a", 1])

    a.pop.should_equal(1)
    a.should_equal(["a"])

    a.pop.should_equal("a")
    a.should_equal([])
  end
  
  it.returns "nil if there are no more elements" do
    [].pop.should_equal(nil)
  end

  it.can "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    empty.pop.should_equal([])

    array = ArraySpecs.recursive_array
    array.pop.should_equal([1, 'two', 3.0, array, array, array, array])
  end

  compliant_on :ruby, :jruby, :ir do
    it.raises " a TypeError on a frozen array" do
      lambda { ArraySpecs.frozen_array.pop }.should_raise(TypeError)
    end
  end
end
