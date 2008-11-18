# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Enumerable#any?" do |it| 
  before :each do
    @enum = EnumerableSpecs::Numerous.new
    @empty = EnumerableSpecs::Empty.new()
    @enum1 = [0, 1, 2, -1]
    @enum2 = [nil, false, true]
  end

  it.can "always returns false on empty enumeration" do
    @empty.any?.should_equal(false)
    @empty.any? { nil }.should_equal(false)

    [].any?.should_equal(false)
    [].any? { false }.should_equal(false)

    {}.any?.should_equal(false)
    {}.any? { nil }.should_equal(false)
  end

  it.raises " an ArgumentError when any arguments provided" do
    lambda { @enum.any?(Proc.new {}) }.should_raise(ArgumentError)
    lambda { @enum.any?(nil) }.should_raise(ArgumentError)
    lambda { @empty.any?(1) }.should_raise(ArgumentError)
    lambda { @enum1.any?(1) {} }.should_raise(ArgumentError)
    lambda { @enum2.any?(1, 2, 3) {} }.should_raise(ArgumentError)
  end

  it.raises " NoMethodError if there is no #each method defined" do
    lambda { EnumerableSpecs::NoEach.new.any? }.should_raise(NoMethodError)
    lambda { EnumerableSpecs::NoEach.new.any? {} }.should_raise(NoMethodError)
  end

  it.does_not "hide exceptions out of #each" do
    lambda {
      EnumerableSpecs::ThrowingEach.new.any?
    }.should_raise(RuntimeError, "from each")

    lambda {
      EnumerableSpecs::ThrowingEach.new.any? { false }
    }.should_raise(RuntimeError, "from each")
  end

  describe "with no block" do |it| 
    it.returns "true if any element is not false or nil" do
      @enum.any?.should_equal(true)
      @enum1.any?.should_equal(true)
      @enum2.any?.should_equal(true)
      EnumerableSpecs::Numerous.new(true).any?.should_equal(true)
      EnumerableSpecs::Numerous.new('a','b','c').any?.should_equal(true)
      EnumerableSpecs::Numerous.new('a','b','c', nil).any?.should_equal(true)
      EnumerableSpecs::Numerous.new(1, nil, 2).any?.should_equal(true)
      EnumerableSpecs::Numerous.new(1, false).any?.should_equal(true)
      EnumerableSpecs::Numerous.new(false, nil, 1, false).any?.should_equal(true)
      EnumerableSpecs::Numerous.new(false, 0, nil).any?.should_equal(true)
    end

    it.returns "false if all elements are false or nil" do
      EnumerableSpecs::Numerous.new(false).any?.should_equal(false)
      EnumerableSpecs::Numerous.new(false, false).any?.should_equal(false)
      EnumerableSpecs::Numerous.new(nil).any?.should_equal(false)
      EnumerableSpecs::Numerous.new(nil, nil).any?.should_equal(false)
      EnumerableSpecs::Numerous.new(nil, false, nil).any?.should_equal(false)
    end
  end

  describe "with block" do |it| 
    it.returns "true if the block ever returns other than false or nil" do
      @enum.any? { true } == true
      @enum.any? { 0 } == true
      @enum.any? { 1 } == true

      @enum1.any? { Object.new } == true
      @enum1.any?{ |o| o < 1 }.should_equal(true)
      @enum1.any?{ |o| 5 }.should_equal(true)

      @enum2.any? { |i| i == nil }.should_equal(true)
    end

    it.can "any? should return false if the block never returns other than false or nil" do
      @enum.any? { false }.should_equal(false)
      @enum.any? { nil }.should_equal(false)

      @enum1.any?{ |o| o < -10 }.should_equal(false)
      @enum1.any?{ |o| nil }.should_equal(false)

      @enum2.any? { |i| i == :stuff }.should_equal(false)
    end

    it.can "stops iterating once the return value is determined" do
      yielded = []
      EnumerableSpecs::Numerous.new(:one, :two, :three).any? do |e|
        yielded << e
        false
      end.should_equal(false)
      yielded.should_equal([:one, :two, :three])

      yielded = []
      EnumerableSpecs::Numerous.new(true, true, false, true).any? do |e|
        yielded << e
        e
      end.should_equal(true)
      yielded.should_equal([true])

      yielded = []
      EnumerableSpecs::Numerous.new(false, nil, false, true, false).any? do |e|
        yielded << e
        e
      end.should_equal(true)
      yielded.should_equal([false, nil, false, true])

      yielded = []
      EnumerableSpecs::Numerous.new(1, 2, 3, 4, 5).any? do |e|
        yielded << e
        e
      end.should_equal(true)
      yielded.should_equal([1])
    end

    it.does_not "hide exceptions out of the block" do
      lambda {
        @enum.any? { raise "from block" }
      }.should_raise(RuntimeError, "from block")
    end
  end
end
