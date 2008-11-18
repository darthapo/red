describe "Array#unshift" do |it|
  it.can "prepend object to the original array" do
    a = [1, 2, 3]
    a.unshift("a").should_equal(a)
    a.should_equal(['a', 1, 2, 3])
    a.unshift().should_equal(a)
    a.should_equal(['a', 1, 2, 3])
    a.unshift(5, 4, 3)
    a.should_equal([5, 4, 3, 'a', 1, 2, 3])

    # shift all but one element
    a = [1, 2]
    a.shift
    a.unshift(3, 4)
    a.should_equal([3, 4, 2])

    # now shift all elements
    a.shift
    a.shift
    a.shift
    a.unshift(3, 4)
    a.should_equal([3, 4])
  end

  it.will "quietly ignore unshifting nothing" do
    [].unshift().should_equal([])
    [].unshift(*[]).should_equal([])
  end

  it.will "properly handle recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    empty.unshift(:new).should_equal([:new, empty])

    array = ArraySpecs.recursive_array
    array.unshift(:new)
    array[0..5].should_equal([:new, 1, 'two', 3.0, array, array])
  end
end
