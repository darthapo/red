# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Array#fill" do |it| 
  before(:all) do
    @never_passed = proc{|i| raise ExpectationNotMetError, "the control path should not pass here" }
  end

  it.returns "self" do
    ary = [1, 2, 3]
    ary.fill(:a).should_equal(ary)
  end

  it.is "destructive" do
    ary = [1, 2, 3]
    ary.fill(:a)
    ary.should_equal([:a, :a, :a])
  end

  it.does_not "replicate the filler" do
    ary = [1, 2, 3, 4]
    str = "x"
    ary.fill(str).should_equal([str, str, str, str])
    str << "y"
    ary.should_equal([str, str, str, str])
    ary[0].should_equal(str)
    ary[1].should_equal(str)
    ary[2].should_equal(str)
    ary[3].should_equal(str)
  end

  it.will "replace all elements in the array with the filler if not given a index nor a length" do
    ary = ['a', 'b', 'c', 'duh']
    ary.fill(8).should_equal([8, 8, 8, 8])

    str = "x"
    ary.fill(str).should_equal([str, str, str, str])
  end

  it.will "replace all elements with the value of block (index given to block)" do
    [nil, nil, nil, nil].fill { |i| i * 2 }.should_equal([0, 2, 4, 6])
  end

  compliant_on :ruby, :jruby, :ir do



  it.raises " an ArgumentError if 4 or more arguments are passed when no block given" do
    lambda { [].fill('a') }.should_not raise_error(ArgumentError)
    lambda { [].fill('a', 1) }.should_not raise_error(ArgumentError)
    lambda { [].fill('a', 1, 2) }.should_not raise_error(ArgumentError)
    lambda { [].fill('a', 1, 2, true) }.should_raise(ArgumentError)
  end

  it.raises " an ArgumentError if no argument passed and no block given" do
    lambda { [].fill }.should_raise(ArgumentError)
  end

  it.raises " an ArgumentError if 3 or more arguments are passed when a block given" do
    lambda { [].fill() {|i|} }.should_not raise_error(ArgumentError)
    lambda { [].fill(1) {|i|} }.should_not raise_error(ArgumentError)
    lambda { [].fill(1, 2) {|i|} }.should_not raise_error(ArgumentError)
    lambda { [].fill(1, 2, true) {|i|} }.should_raise(ArgumentError)
  end
end

describe "Array#fill with (filler, index, length)" do |it| 
  it.will "replace length elements beginning with the index with the filler if given an index and a length" do
    ary = [1, 2, 3, 4, 5, 6]
    ary.fill('x', 2, 3).should_equal([1, 2, 'x', 'x', 'x', 6])
  end

  it.will "replace length elements beginning with the index with the value of block" do
    [true, false, true, false, true, false, true].fill(1, 4) { |i| i + 3 }.should_equal([true, 4, 5, 6, 7, false, true])
  end

  it.will "replace all elements after the index if given an index and no length " do
    ary = [1, 2, 3]
    ary.fill('x', 1).should_equal([1, 'x', 'x'])
    ary.fill(1){|i| i*2}.should_equal([1, 2, 4])
  end

  it.will "replace all elements after the index if given an index and nil as a length" do
    a = [1, 2, 3]
    a.fill('x', 1, nil).should_equal([1, 'x', 'x'])
    a.fill(1, nil){|i| i*2}.should_equal([1, 2, 4])
  end

  it.will "replace the last (-n) elements if given an index n which is negative and no length" do
    a = [1, 2, 3, 4, 5]
    a.fill('x', -2).should_equal([1, 2, 3, 'x', 'x'])
    a.fill(-2){|i| i.to_s}.should_equal([1, 2, 3, '3', '4'])
  end

  it.will "replace the last (-n) elements if given an index n which is negative and nil as a length" do
    a = [1, 2, 3, 4, 5]
    a.fill('x', -2, nil).should_equal([1, 2, 3, 'x', 'x'])
    a.fill(-2, nil){|i| i.to_s}.should_equal([1, 2, 3, '3', '4'])
  end

  it.can "makes no modifications if given an index greater than end and no length" do
    [1, 2, 3, 4, 5].fill('a', 5).should_equal([1, 2, 3, 4, 5])
    [1, 2, 3, 4, 5].fill(5, &@never_passed).should_equal([1, 2, 3, 4, 5])
  end

  it.can "makes no modifications if given an index greater than end and nil as a length" do
    [1, 2, 3, 4, 5].fill('a', 5, nil).should_equal([1, 2, 3, 4, 5])
    [1, 2, 3, 4, 5].fill(5, nil, &@never_passed).should_equal([1, 2, 3, 4, 5])
  end

  it.will "replace length elements beginning with start index if given an index >= 0 and a length >= 0" do
    [1, 2, 3, 4, 5].fill('a', 2, 0).should_equal([1, 2, 3, 4, 5])
    [1, 2, 3, 4, 5].fill('a', 2, 2).should_equal([1, 2, "a", "a", 5])

    [1, 2, 3, 4, 5].fill(2, 0, &@never_passed).should_equal([1, 2, 3, 4, 5])
    [1, 2, 3, 4, 5].fill(2, 2){|i| i*2}.should_equal([1, 2, 4, 6, 5])
  end

  it.can "increases the Array size when necessary" do
    a = [1, 2, 3]
    a.size.should_equal(3)
    a.fill 'a', 0, 10
    a.size.should_equal(10 )
  end

  it.can "pads between the last element and the index with nil if given an index which is greater than size of the array" do
    [1, 2, 3, 4, 5].fill('a', 8, 5).should_equal([1, 2, 3, 4, 5, nil, nil, nil, 'a', 'a', 'a', 'a', 'a'])
    [1, 2, 3, 4, 5].fill(8, 5){|i| 'a'}.should_equal([1, 2, 3, 4, 5, nil, nil, nil, 'a', 'a', 'a', 'a', 'a'])
  end

  it.will "replace length elements beginning with the (-n)th if given an index n < 0 and a length > 0" do
    [1, 2, 3, 4, 5].fill('a', -2, 2).should_equal([1, 2, 3, "a", "a"])
    [1, 2, 3, 4, 5].fill('a', -2, 4).should_equal([1, 2, 3, "a", "a", "a", "a"])

    [1, 2, 3, 4, 5].fill(-2, 2){|i| 'a'}.should_equal([1, 2, 3, "a", "a"])
    [1, 2, 3, 4, 5].fill(-2, 4){|i| 'a'}.should_equal([1, 2, 3, "a", "a", "a", "a"])
  end

  it.will "start at 0 if the negative index is before the start of the array" do
    [1, 2, 3, 4, 5].fill('a', -25, 3).should_equal(['a', 'a', 'a', 4, 5])
    [1, 2, 3, 4, 5].fill('a', -10, 10).should_equal(%w|a a a a a a a a a a|)

    [1, 2, 3, 4, 5].fill(-25, 3){|i| 'a'}.should_equal(['a', 'a', 'a', 4, 5])
    [1, 2, 3, 4, 5].fill(-10, 10){|i| 'a'}.should_equal(%w|a a a a a a a a a a|)
  end

  it.can "makes no modifications if the given length <= 0" do
    [1, 2, 3, 4, 5].fill('a', 2, 0).should_equal([1, 2, 3, 4, 5])
    [1, 2, 3, 4, 5].fill('a', 2, -2).should_equal([1, 2, 3, 4, 5])
    [1, 2, 3, 4, 5].fill('a', -2, -2).should_equal([1, 2, 3, 4, 5])
    [1, 2, 3, 4, 5].fill('a', -2, 0).should_equal([1, 2, 3, 4, 5])

    [1, 2, 3, 4, 5].fill(2, 0, &@never_passed).should_equal([1, 2, 3, 4, 5])
    [1, 2, 3, 4, 5].fill(2, -2, &@never_passed).should_equal([1, 2, 3, 4, 5])
    [1, 2, 3, 4, 5].fill(-2, -2, &@never_passed).should_equal([1, 2, 3, 4, 5])
    [1, 2, 3, 4, 5].fill(-2, 0, &@never_passed).should_equal([1, 2, 3, 4, 5])
  end

  # See: http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-core/17481
  it.does_not "raise an exception if the given length is negative and its absolute value does not exceed the index" do
    lambda { [1, 2, 3, 4].fill('a', 3, -1)}.should_not raise_error(ArgumentError)
    lambda { [1, 2, 3, 4].fill('a', 3, -2)}.should_not raise_error(ArgumentError)
    lambda { [1, 2, 3, 4].fill('a', 3, -3)}.should_not raise_error(ArgumentError)

    lambda { [1, 2, 3, 4].fill(3, -1, &@never_passed)}.should_not raise_error(ArgumentError)
    lambda { [1, 2, 3, 4].fill(3, -2, &@never_passed)}.should_not raise_error(ArgumentError)
    lambda { [1, 2, 3, 4].fill(3, -3, &@never_passed)}.should_not raise_error(ArgumentError)
  end
  it.does_not "raise an exception even if the given length is negative and its absolute value exceeds the index" do
    lambda { [1, 2, 3, 4].fill('a', 3, -4)}.should_not raise_error(ArgumentError)
    lambda { [1, 2, 3, 4].fill('a', 3, -5)}.should_not raise_error(ArgumentError)
    lambda { [1, 2, 3, 4].fill('a', 3, -10000)}.should_not raise_error(ArgumentError)

    lambda { [1, 2, 3, 4].fill(3, -4, &@never_passed)}.should_not raise_error(ArgumentError)
    lambda { [1, 2, 3, 4].fill(3, -5, &@never_passed)}.should_not raise_error(ArgumentError)
    lambda { [1, 2, 3, 4].fill(3, -10000, &@never_passed)}.should_not raise_error(ArgumentError)
  end

  it.tries "to convert the second and third arguments to Integers using #to_int" do
    obj = mock('to_int')
    obj.should_receive(:to_int).and_return(2, 2)
    filler = mock('filler')
    filler.should_not_receive(:to_int)
    [1, 2, 3, 4, 5].fill(filler, obj, obj).should_equal([1, 2, filler, filler, 5])
  end
  
  it.checks "whether the passed arguments respond to #to_int" do
    obj = mock('method_missing to_int')
    obj.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_int).twice.and_return(2)
    [1, 2, 3, 4, 5].fill('a', obj, obj).should_equal([1, 2, "a", "a", 5])
  end

  it.raises " a TypeError if the index is not numeric" do
    lambda { [].fill 'a', true }.should_raise(TypeError)

    obj = mock('nonnumeric')
    obj.should_receive(:respond_to?).with(:to_int).and_return(false)
    lambda { [].fill('a', obj) }.should_raise(TypeError)
  end
  
  platform_is :wordsize => 32 do
    it.raises " an ArgumentError or RangeError for too-large sizes" do
      arr = [1, 2, 3]
      lambda { arr.fill(10, 1, 2**31 - 1) }.should_raise(ArgumentError)
      lambda { arr.fill(10, 1, 2**31) }.should_raise(RangeError)
    end
  end

  platform_is :wordsize => 64 do
    it.raises " an ArgumentError or RangeError for too-large sizes" do
      arr = [1, 2, 3]
      lambda { arr.fill(10, 1, 2**63 - 1) }.should_raise(ArgumentError)
      lambda { arr.fill(10, 1, 2**63) }.should_raise(RangeError)
    end
  end
end

describe "Array#fill with (filler, range)" do |it| 
  it.will "replace elements in range with object" do
    [1, 2, 3, 4, 5, 6].fill(8, 0..3).should_equal([8, 8, 8, 8, 5, 6])
    [1, 2, 3, 4, 5, 6].fill(8, 0...3).should_equal([8, 8, 8, 4, 5, 6])
    [1, 2, 3, 4, 5, 6].fill('x', 4..6).should_equal([1, 2, 3, 4, 'x', 'x', 'x'])
    [1, 2, 3, 4, 5, 6].fill('x', 4...6).should_equal([1, 2, 3, 4, 'x', 'x'])
    [1, 2, 3, 4, 5, 6].fill('x', -2..-1).should_equal([1, 2, 3, 4, 'x', 'x'])
    [1, 2, 3, 4, 5, 6].fill('x', -2...-1).should_equal([1, 2, 3, 4, 'x', 6])
    [1, 2, 3, 4, 5, 6].fill('x', -2...-2).should_equal([1, 2, 3, 4, 5, 6])
    [1, 2, 3, 4, 5, 6].fill('x', -2..-2).should_equal([1, 2, 3, 4, 'x', 6])
    [1, 2, 3, 4, 5, 6].fill('x', -2..0).should_equal([1, 2, 3, 4, 5, 6])
    [1, 2, 3, 4, 5, 6].fill('x', 0...0).should_equal([1, 2, 3, 4, 5, 6])
    [1, 2, 3, 4, 5, 6].fill('x', 1..1).should_equal([1, 'x', 3, 4, 5, 6])
  end
  
  it.will "replace all elements in range with the value of block" do
    [1, 1, 1, 1, 1, 1].fill(1..6) { |i| i + 1 }.should_equal([1, 2, 3, 4, 5, 6, 7])
  end

  it.can "increases the Array size when necessary" do
    [1, 2, 3].fill('x', 1..6).should_equal([1, 'x', 'x', 'x', 'x', 'x', 'x'])
    [1, 2, 3].fill(1..6){|i| i+1}.should_equal([1, 2, 3, 4, 5, 6, 7])
  end

  it.raises " a TypeError with range and length argument" do
    lambda { [].fill('x', 0 .. 2, 5) }.should_raise(TypeError)
  end

  it.will "replace elements between the (-m)th to the last and the (n+1)th from the first if given an range m..n where m < 0 and n >= 0" do
    [1, 2, 3, 4, 5, 6].fill('x', -4..4).should_equal([1, 2, 'x', 'x', 'x', 6])
    [1, 2, 3, 4, 5, 6].fill('x', -4...4).should_equal([1, 2, 'x', 'x', 5, 6])

    [1, 2, 3, 4, 5, 6].fill(-4..4){|i| (i+1).to_s}.should_equal([1, 2, '3', '4', '5', 6])
    [1, 2, 3, 4, 5, 6].fill(-4...4){|i| (i+1).to_s}.should_equal([1, 2, '3', '4', 5, 6])
  end

  it.will "replace elements between the (-m)th and (-n)th to the last if given an range m..n where m < 0 and n < 0" do
    [1, 2, 3, 4, 5, 6].fill('x', -4..-2).should_equal([1, 2, 'x', 'x', 'x', 6])
    [1, 2, 3, 4, 5, 6].fill('x', -4...-2).should_equal([1, 2, 'x', 'x', 5, 6])

    [1, 2, 3, 4, 5, 6].fill(-4..-2){|i| (i+1).to_s}.should_equal([1, 2, '3', '4', '5', 6])
    [1, 2, 3, 4, 5, 6].fill(-4...-2){|i| (i+1).to_s}.should_equal([1, 2, '3', '4', 5, 6])
  end

  it.will "replace elements between the (m+1)th from the first and (-n)th to the last if given an range m..n where m >= 0 and n < 0" do
    [1, 2, 3, 4, 5, 6].fill('x', 2..-2).should_equal([1, 2, 'x', 'x', 'x', 6])
    [1, 2, 3, 4, 5, 6].fill('x', 2...-2).should_equal([1, 2, 'x', 'x', 5, 6])

    [1, 2, 3, 4, 5, 6].fill(2..-2){|i| (i+1).to_s}.should_equal([1, 2, '3', '4', '5', 6])
    [1, 2, 3, 4, 5, 6].fill(2...-2){|i| (i+1).to_s}.should_equal([1, 2, '3', '4', 5, 6])
  end

  it.can "makes no modifications if given an range which implies a section of zero width" do
    [1, 2, 3, 4, 5, 6].fill('x', 2...2).should_equal([1, 2, 3, 4, 5, 6])
    [1, 2, 3, 4, 5, 6].fill('x', -4...2).should_equal([1, 2, 3, 4, 5, 6])
    [1, 2, 3, 4, 5, 6].fill('x', -4...-4).should_equal([1, 2, 3, 4, 5, 6])
    [1, 2, 3, 4, 5, 6].fill('x', 2...-4).should_equal([1, 2, 3, 4, 5, 6])

    [1, 2, 3, 4, 5, 6].fill(2...2, &@never_passed).should_equal([1, 2, 3, 4, 5, 6])
    [1, 2, 3, 4, 5, 6].fill(-4...2, &@never_passed).should_equal([1, 2, 3, 4, 5, 6])
    [1, 2, 3, 4, 5, 6].fill(-4...-4, &@never_passed).should_equal([1, 2, 3, 4, 5, 6])
    [1, 2, 3, 4, 5, 6].fill(2...-4, &@never_passed).should_equal([1, 2, 3, 4, 5, 6])
  end

  it.can "makes no modifications if given an range which implies a section of negative width" do
    [1, 2, 3, 4, 5, 6].fill('x', 2..1).should_equal([1, 2, 3, 4, 5, 6])
    [1, 2, 3, 4, 5, 6].fill('x', -4..1).should_equal([1, 2, 3, 4, 5, 6])
    [1, 2, 3, 4, 5, 6].fill('x', -2..-4).should_equal([1, 2, 3, 4, 5, 6])
    [1, 2, 3, 4, 5, 6].fill('x', 2..-5).should_equal([1, 2, 3, 4, 5, 6])

    [1, 2, 3, 4, 5, 6].fill(2..1, &@never_passed).should_equal([1, 2, 3, 4, 5, 6])
    [1, 2, 3, 4, 5, 6].fill(-4..1, &@never_passed).should_equal([1, 2, 3, 4, 5, 6])
    [1, 2, 3, 4, 5, 6].fill(-2..-4, &@never_passed).should_equal([1, 2, 3, 4, 5, 6])
    [1, 2, 3, 4, 5, 6].fill(2..-5, &@never_passed).should_equal([1, 2, 3, 4, 5, 6])
  end

  it.can "raise an exception if some of the given range lies before the first of the array" do
    lambda { [1, 2, 3].fill('x', -5..-3) }.should_raise(RangeError, /-5\.\.-3/)
    lambda { [1, 2, 3].fill('x', -5...-3) }.should_raise(RangeError, /-5\.\.\.-3/)
    lambda { [1, 2, 3].fill('x', -5..-4) }.should_raise(RangeError, /-5\.\.-4/)

    lambda { [1, 2, 3].fill(-5..-3, &@never_passed) }.should_raise(RangeError, /-5\.\.-3/)
    lambda { [1, 2, 3].fill(-5...-3, &@never_passed) }.should_raise(RangeError, /-5\.\.\.-3/)
    lambda { [1, 2, 3].fill(-5..-4, &@never_passed) }.should_raise(RangeError, /-5\.\.-4/)
  end

  it.tries "to convert the start and end of the passed range to Integers using #to_int" do
    obj = mock('to_int')
    def obj.<=>(rhs); rhs == self ? 0 : nil end
    obj.should_receive(:to_int).twice.and_return(2)
    filler = mock('filler')
    filler.should_not_receive(:to_int)
    [1, 2, 3, 4, 5].fill(filler, obj..obj).should_equal([1, 2, filler, 4, 5])
  end
  
  it.checks "whether the start and end of the passed range respond to #to_int" do
    obj = mock('method_missing to_int')
    def obj.<=>(rhs); rhs == self ? 0 : nil end
    obj.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_int).twice.and_return(2)
    [1, 2, 3, 4, 5].fill('a', obj..obj).should_equal([1, 2, "a", 4, 5])
  end

  it.raises " a TypeError if the start or end of the passed range is not numeric" do
    obj = mock('nonnumeric')
    def obj.<=>(rhs); rhs == self ? 0 : nil end
    obj.should_receive(:respond_to?).with(:to_int).and_return(false)
    lambda { [].fill('a', obj..obj) }.should_raise(TypeError)
  end
end
