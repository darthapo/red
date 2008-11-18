describe "Array#<<" do |it|
  it.can "push the object onto the end of the array" do
    ([ 1, 2 ] << "c" << "d" << [ 3, 4 ]).should_equal([1, 2, "c", "d", [3, 4]])
  end

  it.returns "self to allow chaining" do
    a = []
    b = a
    (a << 1).should_equal(b)
    (a << 2 << 3).should_equal(b)
  end

  it.can "resize the Array" do
    a = []
    a.size.should_equal(0)
    a << :foo
    a.size.should_equal(1)
    a << :bar << :baz
    a.size.should_equal(3)

    a = [1, 2, 3]
    a.shift
    a.shift
    a.shift
    a << :foo
    a.should_equal([:foo])
  end
end
