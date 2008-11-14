describe "Array#values_at" do |it|
  it.returns "an array of elements at the indexes when passed indexes" do
    [1, 2, 3, 4, 5].values_at().should_equal([])
    [1, 2, 3, 4, 5].values_at(1, 0, 5, -1, -8, 10).should_equal([2, 1, nil, 5, nil, nil])
  end

  it.can "call to_int on its indices" do
    obj = mock('1')
    def obj.to_int() 1 end
    [1, 2].values_at(obj, obj, obj).should_equal([2, 2, 2])
  end
  
  it.can "check whether the start and length respond to #to_int" do
    obj = mock('1')
    obj.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_int).and_return(1)
    [1, 2].values_at(obj).should_equal([2])
  end
  
  it.returns "an array of elements in the ranges when passes ranges" do
    [1, 2, 3, 4, 5].values_at(0..2, 1...3, 4..6).should_equal([1, 2, 3, 2, 3, 5, nil])
    [1, 2, 3, 4, 5].values_at(6..4).should_equal([])
  end

  it.will "properly handle recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    empty.values_at(0, 1, 2).should_equal([empty, nil, nil])

    array = ArraySpecs.recursive_array
    array.values_at(0, 1, 2, 3).should_equal([1, 'two', 3.0, array])
  end

  it.can "call to_int on arguments of ranges when passes ranges" do
    from = mock('from')
    to = mock('to')

    # So we can construct a range out of them...
    def from.<=>(o) 0 end
    def to.<=>(o) 0 end

    def from.to_int() 1 end
    def to.to_int() -2 end
      
    ary = [1, 2, 3, 4, 5]
    ary.values_at(from .. to, from ... to, to .. from).should_equal([2, 3, 4, 2, 3])
  end

  it.can "check whether the range arguments respond to #to_int" do
    from = mock('from')
    to = mock('to')

    def from.<=>(o) 0 end
    def to.<=>(o) 0 end

    from.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    from.should_receive(:method_missing).with(:to_int).and_return(1)
    to.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    to.should_receive(:method_missing).with(:to_int).and_return(-2)

    ary = [1, 2, 3, 4, 5]
    ary.values_at(from .. to).should_equal([2, 3, 4])
  end

  it.does_not "return subclass instance on Array subclasses" do
    ArraySpecs::MyArray[1, 2, 3].values_at(0, 1..2, 1).class.should_equal(Array)
  end  
end
