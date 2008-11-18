# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Array#select" do |it| 
  it.returns "a new array of elements for which block is true" do
    [1, 3, 4, 5, 6, 9].select { |i| i % ((i + 1) / 2) == 0}.should_equal([1, 4, 6])
  end

  it.does_not "return subclass instance on Array subclasses" do
    ArraySpecs::MyArray[1, 2, 3].select { true }.class.should_equal(Array)
  end

  it.can "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    empty.select { true }.should_equal(empty)
    empty.select { false }.should_equal([])

    array = ArraySpecs.recursive_array
    array.select { true }.should_equal([1, 'two', 3.0, array, array, array, array, array])
    array.select { false }.should_equal([])
  end
end
