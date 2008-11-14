module ArraySpecs
  class SortSame
    def <=>(other); 0; end
    def ==(other); true; end
  end

  class UFOSceptic
    def <=>(other); raise "N-uh, UFO:s do not exist!"; end
  end

  class MockForCompared
    @@count = 0
    @@compared = false
    def initialize
      @@compared = false
      @order = (@@count += 1)
    end
    def <=>(rhs)
      @@compared = true
      return rhs.order <=> self.order
    end
    def self.compared?
      @@compared
    end

    protected
    attr_accessor :order
  end
end


describe "Array#sort" do |it|
  it.returns "a new array sorted based on comparing elements with <=>" do
    a = [1, -2, 3, 9, 1, 5, -5, 1000, -5, 2, -10, 14, 6, 23, 0]
    a.sort.should_equal([-10, -5, -5, -2, 0, 1, 1, 2, 3, 5, 6, 9, 14, 23, 1000])
  end

  it.does_not "affect the original Array" do
    a = [0, 15, 2, 3, 4, 6, 14, 5, 7, 12, 8, 9, 1, 10, 11, 13]
    b = a.sort
    a.should_equal([0, 15, 2, 3, 4, 6, 14, 5, 7, 12, 8, 9, 1, 10, 11, 13])
    b.should_equal((0..15).to_a)
  end

  it.can "sort already-sorted Arrays" do
    (0..15).to_a.sort.should_equal((0..15).to_a)
  end

  it.can "sort reverse-sorted Arrays" do
    (0..15).to_a.reverse.sort.should_equal((0..15).to_a)
  end

  it.can "sort Arrays that consist entirely of equal elements" do
    a = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    a.sort.should_equal(a)
    b = Array.new(15).map { ArraySpecs::SortSame.new }
    b.sort.should_equal(b)
  end

  it.can "sorts Arrays that consist mostly of equal elements" do
    a = [1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    a.sort.should_equal([0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1])
  end

  it.does_not "return self even if the array would be already sorted" do
    a = [1, 2, 3]
    sorted = a.sort
    sorted.should_equal(a)
    sorted.should_not equal(a)
  end

  it.can "properly handle recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    empty.sort.should_equal(empty)

    array = [[]]; array << array
    array.sort.should_equal([[], array])
  end

  it.can "use #<=> of elements in order to sort" do
    a = ArraySpecs::MockForCompared.new
    b = ArraySpecs::MockForCompared.new
    c = ArraySpecs::MockForCompared.new

    ArraySpecs::MockForCompared.compared?.should_equal(false)
    [a, b, c].sort.should_equal([c, b, a])
    ArraySpecs::MockForCompared.compared?.should_equal(true)
  end

  it.does_not "deal with exceptions raised by unimplemented or incorrect #<=>" do
    o = Object.new

    lambda { [o, 1].sort }.should_raise
  end

  it.can "take a block which is used to determine the order of objects a and b described as -1, 0 or +1" do
    a = [5, 1, 4, 3, 2]
    a.sort.should_equal([1, 2, 3, 4, 5])
    a.sort {|x, y| y <=> x}.should_equal([5, 4, 3, 2, 1])
  end

  it.does_not "call #<=> on contained objects when invoked with a block" do
    a = Array.new(25)
    (0...25).each {|i| a[i] = ArraySpecs::UFOSceptic.new }

    a.sort { -1 }.class.should_equal(Array)
  end

  it.does_not "call #<=> on elements when invoked with a block even if Array is large (Rubinius #412)" do
    a = Array.new(1500)
    (0...1500).each {|i| a[i] = ArraySpecs::UFOSceptic.new }

    a.sort { -1 }.class.should_equal(Array)
  end

  it.will "complete when supplied a block that always returns the same result" do
    a = [2, 3, 5, 1, 4]
    a.sort {  1 }.class.should_equal(Array)
    a.sort {  0 }.class.should_equal(Array)
    a.sort { -1 }.class.should_equal(Array)
  end

  it.returns "return subclass instance on Array subclasses" do
    ary = ArraySpecs::MyArray[1, 2, 3]
    ary.sort.class.should_equal(ArraySpecs::MyArray)
  end

  it.does_not "freezes self during being sorted" do
    a = [1, 2, 3]
    a.sort { |x,y| a.frozen?.should_equal(false; x <=> y })
  end

  it.returns "the specified value when it would break in the given block" do
    [1, 2, 3].sort{ break :a }.should_equal(:a)
  end
end

describe "Array#sort!" do |it|
  it.can "sort array in place using <=>" do
    a = [1, -2, 3, 9, 1, 5, -5, 1000, -5, 2, -10, 14, 6, 23, 0]
    a.sort!
    a.should_equal([-10, -5, -5, -2, 0, 1, 1, 2, 3, 5, 6, 9, 14, 23, 1000])
  end

  it.can "sort array in place using block value if a block given" do
    a = [0, 15, 2, 3, 4, 6, 14, 5, 7, 12, 8, 9, 1, 10, 11, 13]
    a.sort! { |x, y| y <=> x }.should_equal((0..15).to_a.reverse)
  end

  it.returns "self if the order of elements changed" do
    a = [6, 7, 2, 3, 7]
    a.sort!.should_equal(a)
    a.should_equal([2, 3, 6, 7, 7])
  end

  it.returns "self even if makes no modification" do
    a = [1, 2, 3, 4, 5]
    a.sort!.should_equal(a)
    a.should_equal([1, 2, 3, 4, 5])
  end

  it.can "properly handle recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    empty.sort!.should_equal(empty)

    array = [[]]; array << array
    array.sort!.should_equal(array)
  end

  it.will "use #<=> of elements in order to sort" do
    a = ArraySpecs::MockForCompared.new
    b = ArraySpecs::MockForCompared.new
    c = ArraySpecs::MockForCompared.new

    ArraySpecs::MockForCompared.compared?.should_equal(false)
    [a, b, c].sort!.should_equal([c, b, a])
    ArraySpecs::MockForCompared.compared?.should_equal(true)
  end

  it.does_not "call #<=> on contained objects when invoked with a block" do
    a = Array.new(25)
    (0...25).each {|i| a[i] = ArraySpecs::UFOSceptic.new }

    a.sort! { -1 }.class.should_equal(Array)
  end

  it.does_not "call #<=> on elements when invoked with a block even if Array is large (Rubinius #412)" do
    a = Array.new(1500)
    (0...1500).each {|i| a[i] = ArraySpecs::UFOSceptic.new }

    a.sort! { -1 }.class.should_equal(Array)
  end

  it.will "complete when supplied a block that always returns the same result" do
    a = [2, 3, 5, 1, 4]
    a.sort!{  1 }.class.should_equal(Array)
    a.sort!{  0 }.class.should_equal(Array)
    a.sort!{ -1 }.class.should_equal(Array)
  end

  it.returns "the specified value when it would break in the given block" do
    [1, 2, 3].sort{ break :a }.should_equal(:a)
  end

  it.will "make some modification even if finished sorting when it would break in the given block" do
    partially_sorted = (1..5).map{|i|
      ary = [5, 4, 3, 2, 1]
      ary.sort!{|x,y| break if x==i; x<=>y}
      ary
    }
    partially_sorted.any?{|ary| ary != [1, 2, 3, 4, 5]}.should_be_true
  end
end
