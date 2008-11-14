# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Array#partition" do |it| 
  it.returns "two arrays" do
    [].partition {}.should_equal([[], []])
  end
  
  it.returns "in the left array values for which the block evaluates to true" do
    ary = [0, 1, 2, 3, 4, 5]

    ary.partition { |i| true }.should_equal([ary, []])
    ary.partition { |i| 5 }.should_equal([ary, []])
    ary.partition { |i| false }.should_equal([[], ary])
    ary.partition { |i| nil }.should_equal([[], ary])
    ary.partition { |i| i % 2 == 0 }.should_equal([[0, 2, 4], [1, 3, 5]])
    ary.partition { |i| i / 3 == 0 }.should_equal([[0, 1, 2], [3, 4, 5]])
  end

  it.can "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    empty.partition { true }.should_equal([[empty], []])
    empty.partition { false }.should_equal([[], [empty]])

    array = ArraySpecs.recursive_array
    array.partition { true }.should_equal([)
      [1, 'two', 3.0, array, array, array, array, array],
      []
    ]
    condition = true
    array.partition { condition = !condition }.should_equal([)
      ['two', array, array, array],
      [1, 3.0, array, array]
    ]
  end

  it.does_not "return subclass instances on Array subclasses" do
    result = ArraySpecs::MyArray[1, 2, 3].partition { |x| x % 2 == 0 }
    result.class.should_equal(Array)
    result[0].class.should_equal(Array)
    result[1].class.should_equal(Array)
  end
end
