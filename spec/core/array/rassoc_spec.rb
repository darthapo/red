# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Array#rassoc" do |it| 
  it.returns "the first contained array whose second element is == object" do
    ary = [[1, "a", 0.5], [2, "b"], [3, "b"], [4, "c"], [], [5], [6, "d"]]
    ary.rassoc("a").should_equal([1, "a", 0.5])
    ary.rassoc("b").should_equal([2, "b"])
    ary.rassoc("d").should_equal([6, "d"])
    ary.rassoc("z").should_equal(nil)
  end

  it.can "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    empty.rassoc([]).should_be_nil
    [[empty, empty]].rassoc(empty).should_equal([empty, empty])

    array = ArraySpecs.recursive_array
    array.rassoc(array).should_be_nil
    [[empty, array]].rassoc(array).should_equal([empty, array])
  end

  it.calls " elem == obj on the second element of each contained array" do
    key = 'foobar'
    o = mock('foobar')
    def o.==(other); other == 'foobar'; end

    [[1, :foobar], [2, o], [3, mock('foo')]].rassoc(key).should_equal([2, o])
  end

  it.does_not "check the last element in each contained but speficically the second" do
    key = 'foobar'
    o = mock('foobar')
    def o.==(other); other == 'foobar'; end

    [[1, :foobar, o], [2, o, 1], [3, mock('foo')]].rassoc(key).should_equal([2, o, 1])
  end
end
