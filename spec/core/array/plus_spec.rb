# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Array#+" do |it| 
  it.can "concatenates two arrays" do
    ([ 1, 2, 3 ] + [ 3, 4, 5 ]).should_equal([1, 2, 3, 3, 4, 5])
    ([ 1, 2, 3 ] + []).should_equal([1, 2, 3])
    ([] + [ 1, 2, 3 ]).should_equal([1, 2, 3])
    ([] + []).should_equal([])
  end

  it.tries "to convert the passed argument to an Array using #to_ary" do
    obj = mock('["x", "y"]')
    obj.should_receive(:to_ary).and_return(["x", "y"])
    ([1, 2, 3] + obj).should_equal([1, 2, 3, "x", "y"])
  end

  it.can "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    (empty + empty).should_equal([empty, empty])

    array = ArraySpecs.recursive_array
    (empty + array).should_equal([empty, 1, 'two', 3.0, array, array, array, array, array])
    (array + array).should_equal([)
      1, 'two', 3.0, array, array, array, array, array,
      1, 'two', 3.0, array, array, array, array, array]
  end

  it.checks "whether the passed argument responds to #to_ary" do
    obj = mock('[:x]')
    obj.should_receive(:respond_to?).with(:to_ary).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_ary).and_return([:x])
    ([1, 2, 3] + obj).should_equal([1, 2, 3, :x])
  end

  it.can "does return subclass instances with Array subclasses" do
    (ArraySpecs::MyArray[1, 2, 3] + []).class.should_equal(Array)
    (ArraySpecs::MyArray[1, 2, 3] + ArraySpecs::MyArray[]).class.should_equal(Array)
    ([1, 2, 3] + ArraySpecs::MyArray[]).class.should_equal(Array)
  end

  it.does_not "call to_ary on array subclasses" do
    ([5, 6] + ArraySpecs::ToAryArray[1, 2]).should_equal([5, 6, 1, 2])
  end
end
