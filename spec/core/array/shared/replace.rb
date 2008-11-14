describe :array_replace, :shared => true do
  it.will "replace the elements with elements from other array" do
    a = [1, 2, 3, 4, 5]
    b = ['a', 'b', 'c']
    a.send(@method, b).should_equal(a)
    a.should_equal(b)
    a.should_not equal(b)

    a.send(@method, [4] * 10)
    a.should_equal([4] * 10)

    a.send(@method, [])
    a.should_equal([])
  end

  it.can "properly handles recursive arrays" do
    orig = [1, 2, 3]
    empty = ArraySpecs.empty_recursive_array
    orig.send(@method, empty)
    orig.should_equal(empty)

    array = ArraySpecs.recursive_array
    orig.send(@method, array)
    orig.should_equal(array)
  end

  it.returns "self" do
    ary = [1, 2, 3]
    other = [:a, :b, :c]
    ary.send(@method, other).should_equal(ary)
  end

  it.does_not "make self dependent to the original array" do
    ary = [1, 2, 3]
    other = [:a, :b, :c]
    ary.send(@method, other)
    ary.should_equal([:a, :b, :c])
    ary << :d
    ary.should_equal([:a, :b, :c, :d])
    other.should_equal([:a, :b, :c])
  end

  it.tries "to convert the passed argument to an Array using #to_ary" do
    obj = mock('to_ary')
    obj.stub!(:to_ary).and_return([1, 2, 3])
    [].send(@method, obj).should_equal([1, 2, 3])
  end

  it.checks "whether the passed argument responds to #to_ary" do
    obj = mock('method_missing to_ary')
    obj.should_receive(:respond_to?).with(:to_ary).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_ary).and_return([1, 2, 3])
    [].send(@method, obj).should_equal([1, 2, 3])
  end

  it.does_not "call #to_ary on Array subclasses" do
    obj = ArraySpecs::ToAryArray[5, 6, 7]
    obj.should_not_receive(:to_ary)
    [].send(@method, ArraySpecs::ToAryArray[5, 6, 7]).should_equal([5, 6, 7])
  end

  compliant_on :ruby, :jruby, :ir do
    ruby_version_is '' ... '1.9' do
      it.raises " a TypeError on a frozen array" do
        lambda {
          ArraySpecs.frozen_array.send(@method, ArraySpecs.frozen_array)
        }.should_raise(TypeError)
      end
    end
    ruby_version_is '1.9' do
      it.raises " a RuntimeError on a frozen array" do
        lambda {
          ArraySpecs.frozen_array.send(@method, ArraySpecs.frozen_array)
        }.should_raise(RuntimeError)
      end
    end
  end
end
