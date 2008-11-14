describe "Array#slice!" do |it|
  it.will "remove and return the element at index" do
    a = [1, 2, 3, 4]
    a.slice!(10).should_equal(nil)
    a.should_equal([1, 2, 3, 4])
    a.slice!(-10).should_equal(nil)
    a.should_equal([1, 2, 3, 4])
    a.slice!(2).should_equal(3)
    a.should_equal([1, 2, 4])
    a.slice!(-1).should_equal(4)
    a.should_equal([1, 2])
    a.slice!(1).should_equal(2)
    a.should_equal([1])
    a.slice!(-1).should_equal(1)
    a.should_equal([])
    a.slice!(-1).should_equal(nil)
    a.should_equal([])
    a.slice!(0).should_equal(nil)
    a.should_equal([])
  end

  it.will "remove and returns length elements beginning at start" do
    a = [1, 2, 3, 4, 5, 6]
    a.slice!(2, 3).should_equal([3, 4, 5])
    a.should_equal([1, 2, 6])
    a.slice!(1, 1).should_equal([2])
    a.should_equal([1, 6])
    a.slice!(1, 0).should_equal([])
    a.should_equal([1, 6])
    a.slice!(2, 0).should_equal([])
    a.should_equal([1, 6])
    a.slice!(0, 4).should_equal([1, 6])
    a.should_equal([])
    a.slice!(0, 4).should_equal([])
    a.should_equal([])
  end

  it.can "properly handle recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    empty.slice(0).should_equal(empty)

    array = ArraySpecs.recursive_array
    array.slice(4).should_equal(array)
    array.slice(0..3).should_equal([1, 'two', 3.0, array])
  end

  it.calls " to_int on start and length arguments" do
    obj = mock('2')
    def obj.to_int() 2 end

    a = [1, 2, 3, 4, 5]
    a.slice!(obj).should_equal(3)
    a.should_equal([1, 2, 4, 5])
    a.slice!(obj, obj).should_equal([4, 5])
    a.should_equal([1, 2])
    a.slice!(0, obj).should_equal([1, 2])
    a.should_equal([])
  end

  it.will "check whether the start and length respond to #to_int" do
    obj = mock('2')
    obj.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_int).any_number_of_times.and_return(2)
    a = [1, 2, 3, 4, 5]
    a.slice!(obj).should_equal(3)
  end

  it.can "remove and return elements in range" do
    a = [1, 2, 3, 4, 5, 6, 7, 8]
    a.slice!(1..4).should_equal([2, 3, 4, 5])
    a.should_equal([1, 6, 7, 8])
    a.slice!(1...3).should_equal([6, 7])
    a.should_equal([1, 8])
    a.slice!(-1..-1).should_equal([8])
    a.should_equal([1])
    a.slice!(0...0).should_equal([])
    a.should_equal([1])
    a.slice!(0..0).should_equal([1])
    a.should_equal([])
  end

  it.will "call to_int on range arguments" do
    from = mock('from')
    to = mock('to')

    # So we can construct a range out of them...
    def from.<=>(o) 0 end
    def to.<=>(o) 0 end

    def from.to_int() 1 end
    def to.to_int() -2 end

    a = [1, 2, 3, 4, 5]

    a.slice!(from .. to).should_equal([2, 3, 4])
    a.should_equal([1, 5])

    lambda { a.slice!("a" .. "b")  }.should_raise(TypeError)
    lambda { a.slice!(from .. "b") }.should_raise(TypeError)
  end

  it.will "check whether the range arguments respond to #to_int" do
    from = mock('from')
    to = mock('to')

    def from.<=>(o) 0 end
    def to.<=>(o) 0 end

    from.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    from.should_receive(:method_missing).with(:to_int).any_number_of_times.and_return(1)
    to.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    to.should_receive(:method_missing).with(:to_int).any_number_of_times.and_return(-2)

    a = [1, 2, 3, 4, 5]
    a.slice!(from .. to).should_equal([2, 3, 4])
  end
end

describe "Array#slice" do |it|
  it.behaves_like(:array_slice, :slice)
end
