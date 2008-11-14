# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Array#reverse" do |it| 
  it.returns "a new array with the elements in reverse order" do
    [].reverse.should_equal([])
    [1, 3, 5, 2].reverse.should_equal([2, 5, 3, 1])
  end

  it.returns "subclass instance on Array subclasses" do
    ArraySpecs::MyArray[1, 2, 3].reverse.class.should_equal(ArraySpecs::MyArray)
  end

  it.can "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    empty.reverse.should_equal(empty)

    array = ArraySpecs.recursive_array
    array.reverse.should_equal([array, array, array, array, array, 3.0, 'two', 1])
  end
end

describe "Array#reverse!" do |it| 
  it.can "reverses the elements in place" do
    a = [6, 3, 4, 2, 1]
    a.reverse!.should_equal(a)
    a.should_equal([1, 2, 4, 3, 6])
    [].reverse!.should_equal([])
  end

  it.can "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    empty.reverse!.should_equal([empty])

    array = ArraySpecs.recursive_array
    array.reverse!.should_equal([array, array, array, array, array, 3.0, 'two', 1])
  end

  compliant_on :ruby, :jruby, :ir do
    it.raises " a TypeError on a frozen array" do
      lambda { ArraySpecs.frozen_array.reverse! }.should_raise(TypeError)
    end
  end
end
