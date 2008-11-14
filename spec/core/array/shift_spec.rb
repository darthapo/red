describe "Array#shift" do |it|
  it.will "remove and returns the first element" do
    a = [5, 1, 1, 5, 4]
    a.shift.should_equal(5)
    a.should_equal([1, 1, 5, 4])
    a.shift.should_equal(1)
    a.should_equal([1, 5, 4])
    a.shift.should_equal(1)
    a.should_equal([5, 4])
    a.shift.should_equal(5)
    a.should_equal([4])
    a.shift.should_equal(4)
    a.should_equal([])
  end
  
  it.returns "nil when the array is empty" do
    [].shift.should_equal(nil)
  end

  it.can "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    empty.shift.should_equal([])
    empty.should_equal([])

    array = ArraySpecs.recursive_array
    array.shift.should_equal(1)
    array[0..2].should_equal(['two', 3.0, array])
  end

  compliant_on :ruby, :jruby, :ir do
    it.raises " a TypeError on a frozen array" do
      lambda { ArraySpecs.frozen_array.shift }.should_raise(TypeError)
    end
  end
end
