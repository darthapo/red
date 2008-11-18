describe "Array#compact" do |it|
  it.returns "a copy of array with all nil elements removed" do
    a = [1, 2, 4]
    a.compact.should_equal([1, 2, 4])
    a = [1, nil, 2, 4]
    a.compact.should_equal([1, 2, 4])
    a = [1, 2, 4, nil]
    a.compact.should_equal([1, 2, 4])
    a = [nil, 1, 2, 4]
    a.compact.should_equal([1, 2, 4])
  end

  it.does_not "return self" do
    a = [1, 2, 3]
    a.compact.should_not_equal(a)
  end

  it.returns "subclass instance for Array subclasses" do
    ArraySpecs::MyArray[1, 2, 3, nil].compact.class.should_equal(ArraySpecs::MyArray)
  end

  it.will "keep tainted status even if all elements are removed" do
    a = [nil, nil]
    a.taint
    a.compact.tainted?.should_be_true
  end
end

describe "Array#compact!" do |it|
  it.will "remove all nil elements" do
    a = ['a', nil, 'b', false, 'c']
    a.compact!.should_equal(a)
    a.should_equal(["a", "b", false, "c"])
    a = [nil, 'a', 'b', false, 'c']
    a.compact!.should_equal(a)
    a.should_equal(["a", "b", false, "c"])
    a = ['a', 'b', false, 'c', nil]
    a.compact!.should_equal(a)
    a.should_equal(["a", "b", false, "c"])
  end
  
  it.returns "self if some nil elements are removed" do
    a = ['a', nil, 'b', false, 'c']
    a.compact!.object_id.should_equal(a.object_id)
  end
  
  it.returns "nil if there are no nil elements to remove" do
    [1, 2, false, 3].compact!.should_equal(nil)
  end

  it.will "keeps tainted status even if all elements are removed" do
    a = [nil, nil]
    a.taint
    a.compact!
    a.tainted?.should_be_true
  end
end
