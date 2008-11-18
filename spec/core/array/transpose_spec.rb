describe "Array#transpose" do |it|
  it.will "assume an array of arrays and returns the result of transposing rows and columns" do
    [[1, 'a'], [2, 'b'], [3, 'c']].transpose.should_equal([[1, 2, 3], ["a", "b", "c"]])
    [[1, 2, 3], ["a", "b", "c"]].transpose.should_equal([[1, 'a'], [2, 'b'], [3, 'c']])
    [].transpose.should_equal([])
    [[]].transpose.should_equal([])
    [[], []].transpose.should_equal([])
    [[0]].transpose.should_equal([[0]])
    [[0], [1]].transpose.should_equal([[0, 1]])
  end

  it.will "try to convert the passed argument to an Array using #to_ary" do
    obj = mock('[1,2]')
    obj.should_receive(:to_ary).and_return([1, 2])
    [obj, [:a, :b]].transpose.should_equal([[1, :a], [2, :b]])
  end

  it.can "properly handle recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    empty.transpose.should_equal(empty)

    a = []; a << a
    b = []; b << b
    [a, b].transpose.should_equal([[a, b]])

    a = [1]; a << a
    b = [2]; b << b    
    [a, b].transpose.should_equal([ [1, 2], [a, b] ])
  end

  it.will "check whether the passed argument responds to #to_ary" do
    obj = mock('[1,2]')
    obj.should_receive(:respond_to?).with(:to_ary).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_ary).and_return([1, 2])
    [obj, [:a, :b]].transpose.should_equal([[1, :a], [2, :b]])
  end

  it.should "raise a TypeError if the passed Argument does not respond to #to_ary" do
    lambda { [Object.new, [:a, :b]].transpose }.should_raise(TypeError)
  end

  it.does_not "call to_ary on array subclass elements" do
    ary = [ArraySpecs::ToAryArray[1, 2], ArraySpecs::ToAryArray[4, 6]]
    ary.transpose.should_equal([[1, 4], [2, 6]])
  end

  it.should "raise an IndexError if the arrays are not of the same length" do
    lambda { [[1, 2], [:a]].transpose }.should_raise(IndexError)
  end

  it.does_not "return subclass instance on Array subclasses" do
    result = ArraySpecs::MyArray[ArraySpecs::MyArray[1, 2, 3], ArraySpecs::MyArray[4, 5, 6]].transpose
    result.class.should_equal(Array)
    result[0].class.should_equal(Array)
    result[1].class.should_equal(Array)
  end
end
