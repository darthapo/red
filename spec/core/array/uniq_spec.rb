describe "Array#uniq" do |it|
  it.returns "an array with no duplicates" do
    ["a", "a", "b", "b", "c"].uniq.should_equal(["a", "b", "c"])
  end

  it.will "properly handle recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    empty.uniq.should_equal([empty])

    array = ArraySpecs.recursive_array
    array.uniq.should_equal([1, 'two', 3.0, array])
  end

  it.can "use eql? semantics" do
    [1.0, 1].uniq.should_equal([1.0, 1])
  end

  it.can "compare elements first with hash" do
    # Can't use should_receive because it uses hash internally
    x = mock('0')
    def x.hash() 0 end
    y = mock('0')
    def y.hash() 0 end
  
    [x, y].uniq.should_equal([x, y])
  end
  
  it.does_not "compare elements with different hash codes via eql?" do
    # Can't use should_receive because it uses hash and eql? internally
    x = mock('0')
    def x.eql?(o) raise("Shouldn't receive eql?") end
    y = mock('1')
    def y.eql?(o) raise("Shouldn't receive eql?") end

    def x.hash() 0 end
    def y.hash() 1 end

    [x, y].uniq.should_equal([x, y])
  end
  
  it.can "compare elements with matching hash codes with #eql?" do
    # Can't use should_receive because it uses hash and eql? internally
    a = Array.new(2) do 
      obj = mock('0')

      def obj.hash()
        # It's undefined whether the impl does a[0].eql?(a[1]) or
        # a[1].eql?(a[0]) so we taint both.
        def self.eql?(o) taint; o.taint; false; end
        return 0
      end

      obj
    end

    a.uniq.should_equal(a)
    a[0].tainted?.should_equal(true)
    a[1].tainted?.should_equal(true)

    a = Array.new(2) do 
      obj = mock('0')

      def obj.hash()
        # It's undefined whether the impl does a[0].eql?(a[1]) or
        # a[1].eql?(a[0]) so we taint both.
        def self.eql?(o) taint; o.taint; true; end
        return 0
      end

      obj
    end

    a.uniq.size.should_equal(1)
    a[0].tainted?.should_equal(true)
    a[1].tainted?.should_equal(true)
  end
  
  it.returns "subclass instance on Array subclasses" do
    ArraySpecs::MyArray[1, 2, 3].uniq.class.should_equal(ArraySpecs::MyArray)
  end
end

describe "Array#uniq!" do |it| 
  it.will "modify the array in place" do
    a = [ "a", "a", "b", "b", "c" ]
    a.uniq!
    a.should_equal(["a", "b", "c"])
  end
  
  it.returns "self" do
    a = [ "a", "a", "b", "b", "c" ]
    a.should_equal(a.uniq!)
  end

  it.can "properly handle recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    empty_dup = empty.dup
    empty.uniq!
    empty.should_equal(empty_dup)

    array = ArraySpecs.recursive_array
    expected = array[0..3]
    array.uniq!
    array.should_equal(expected)
  end

  it.returns "nil if no changes are made to the array" do
    [ "a", "b", "c" ].uniq!.should_equal(nil)
  end
end
