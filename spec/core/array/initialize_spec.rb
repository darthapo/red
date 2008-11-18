# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Array#initialize" do |it| 
  it.is "private" do
    [].private_methods.map{|name| name.to_s}.should_include("initialize")
  end

  it.can "raise an ArgumentError if 3 or more arguments passed and no block given" do
    lambda { [1, 2].send(:initialize) }.should_not raise_error(ArgumentError)
    lambda { [1, 2].send(:initialize, 1) }.should_not raise_error(ArgumentError)
    lambda { [1, 2].send(:initialize, 1, 'x') }.should_not raise_error(ArgumentError)
    lambda { [1, 2].send(:initialize, 1, 'x', true) }.should_raise(ArgumentError)
  end

  it.can "raise an ArgumentError if 3 or more arguments passed and a block given" do
    lambda { [1, 2].send(:initialize){} }.should_not raise_error(ArgumentError)
    lambda { [1, 2].send(:initialize, 1){} }.should_not raise_error(ArgumentError)
    lambda { [1, 2].send(:initialize, 1, 'x'){} }.should_not raise_error(ArgumentError)
    lambda { [1, 2].send(:initialize, 1, 'x', true){} }.should_raise(ArgumentError)
  end
  
  compliant_on :ruby, :jruby, :ir do
    ruby_version_is '' ... '1.9' do
      it.raises " a TypeError on frozen arrays even if the array would not be 'modified'" do
        # This is true at least 1.8.6p111 onwards 
        lambda { ArraySpecs.frozen_array.send(:initialize) }.should_raise(TypeError)

        lambda { ArraySpecs.frozen_array.send(:initialize, 1) }.should_raise(TypeError)
        lambda { ArraySpecs.frozen_array.send(:initialize, [1, 2, 3]) }.should_raise(TypeError)
      end
    end
    ruby_version_is '1.9' do
      it.raises " a RuntimeError on frozen arrays even if the array would not be 'modified'" do
        lambda { ArraySpecs.frozen_array.send(:initialize) }.should_raise(RuntimeError)

        lambda { ArraySpecs.frozen_array.send(:initialize, 1) }.should_raise(RuntimeError)
        lambda { ArraySpecs.frozen_array.send(:initialize, [1, 2, 3]) }.should_raise(RuntimeError)
      end
    end
  end
end

describe "Array#initialize with no arguments" do |it| 
  it.returns "self" do
    a = [1, 2, 3]
    a.send(:initialize).should_equal(a)
  end

  it.can "makes the array empty" do
    [1, 2, 3].send(:initialize).should_be_empty
  end

  it.does_not "use the given block" do
    lambda{ [1, 2, 3].send(:initialize) { raise } }.should_not raise_error
  end
end

describe "Array#initialize with (size, object)" do |it| 
  it.is "called on subclasses" do
    a = ArraySpecs::SubArray.new 10
    a.special.should_equal(10)
    a.should_equal([])
  end

  it.will "set the array to size and fills with the object" do
    a = []
    a.send(:initialize, 2, [3])
    a.should_equal([[3], [3]])
    a[0].should_equal(a[1])
  end

  it.will "set the array to size and fills with nil when object is omitted" do
    [].send(:initialize, 3).should_equal([nil, nil, nil])
  end
  
  it.raises " an ArgumentError if size is negative" do
    lambda { [].send(:initialize, -1, :a) }.should_raise(ArgumentError)
    lambda { [1, 2, 3].send(:initialize, -1) }.should_raise(ArgumentError)
  end

  platform_is :wordsize => 32 do
    it.raises " an ArgumentError if size is too large" do
      lambda { [].send(:initialize, 2**32/4+1) }.should_raise(ArgumentError, /size/)
    end
  end
  platform_is :wordsize => 64 do
    it.raises " an ArgumentError if size is too large" do
      lambda { [].send(:initialize, 2**64/8+1) }.should_raise(ArgumentError, /size/)
    end
  end

  it.tries "to convert the passed size argument to an Integer using #to_int" do
    obj = mock('1')
    obj.should_receive(:to_int).and_return(1)
    [1, 2].send(:initialize, obj, :a).should_equal([:a])
  end

  it.checks "whether the passed size argument responds to #to_int" do
    obj = mock('1')
    obj.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_int).and_return(1)
    [1, 2].send(:initialize, obj, :a).should_equal([:a])
  end

  it.raises " a TypeError if the passed size is no numeric" do
    obj = mock('nonnumeric')
    obj.should_receive(:respond_to?).with(:to_int).and_return(false)
    lambda{ [1, 2].send(:initialize, obj) }.should_raise(TypeError)
  end

  it.yields "the given block size times passing an index and fills self with values of the block" do
    [1, 2].send(:initialize, 5){|i| "#{i}"}.should_equal(['0', '1', '2', '3', '4'])
  end

  it.yields "the given block size times passing an index and fills self with values of the block even if a filler value passed" do
    [1, 2].send(:initialize, 5, 'filler'){|i| "#{i}"}.should_equal(['0', '1', '2', '3', '4'])
  end

  it.returns "the specified value if it would break in the given block" do
    [1, 2].send(:initialize, 5){ break :a }.should_equal(:a)
  end

  it.can "makes the array contain values the given block would yield even if it would break in the block" do
    ary = [1, 2, 3, 4, 5]
    ary.send(:initialize, 7) {|i|
      break :a if i == 2
      "#{i}"
    }
    ary.should_equal(['0', '1'])
  end
end

describe "Array#initialize with (array)" do |it| 
  it.will "replace self with the other array" do
    o = [2]
    def o.special() size end
    a = [1, o, 3]
    ary = Array.new a
    ary[1].special.should_equal(1)
    
    b = [1, [2], 3]
    ary.send :initialize, b
    
    b.==(ary).should_equal(true)
    lambda { b[1].special }.should_raise(NoMethodError)
    lambda { ary[1].special }.should_raise(NoMethodError)
  end
  
  it.is "called on subclasses" do
    b = ArraySpecs::SubArray.new [1,2,3]
    b.special.should_equal([1,2,3])
    b.should_equal([])
  end
  
  it.does_not "hing when passed self" do
    ary = [1, 2, 3]
    ary.send(:initialize, ary)
    ary.should_equal([1, 2, 3])
  end

  it.does_not "use the given block" do
    lambda{ [1, 2, 3].send(:initialize) { raise } }.should_not raise_error
  end
end
