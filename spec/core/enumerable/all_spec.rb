# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Enumerable#all?" do |it| 

  before :each do
    @enum = EnumerableSpecs::Numerous.new
    @empty = EnumerableSpecs::Empty.new()
    @enum1 = [0, 1, 2, -1]
    @enum2 = [nil, false, true]
  end

  it.can "always returns true on empty enumeration" do
    @empty.all?.should_equal(true)
    @empty.all? { nil }.should_equal(true)

    [].all?.should_equal(true)
    [].all? { false }.should_equal(true)

    {}.all?.should_equal(true)
    {}.all? { nil }.should_equal(true)
  end

  it.raises " an ArgumentError when any arguments provided" do
    lambda { @enum.all?(Proc.new {}) }.should_raise(ArgumentError)
    lambda { @enum.all?(nil) }.should_raise(ArgumentError)
    lambda { @empty.all?(1) }.should_raise(ArgumentError)
    lambda { @enum1.all?(1) {} }.should_raise(ArgumentError)
    lambda { @enum2.all?(1, 2, 3) {} }.should_raise(ArgumentError)
  end

  it.raises " NoMethodError if there is no #each method defined" do
    lambda { EnumerableSpecs::NoEach.new.all? }.should_raise(NoMethodError)
    lambda { EnumerableSpecs::NoEach.new.all? {} }.should_raise(NoMethodError)
  end

  it.does_not "hide exceptions out of #each" do
    lambda {
      EnumerableSpecs::ThrowingEach.new.all?
    }.should_raise(RuntimeError, "from each")

    lambda {
      EnumerableSpecs::ThrowingEach.new.all? { false }
    }.should_raise(RuntimeError, "from each")
  end

  describe "with no block" do |it| 
    it.returns "true if no elements are false or nil" do
      @enum.all?.should_equal(true)
      @enum1.all?.should_equal(true)
      @enum2.all?.should_equal(false)

      EnumerableSpecs::Numerous.new('a','b','c').all?.should_equal(true)
      EnumerableSpecs::Numerous.new(0, "x", true).all?.should_equal(true)
    end

    it.returns "false if there are false or nil elements" do
      EnumerableSpecs::Numerous.new(false).all?.should_equal(false)
      EnumerableSpecs::Numerous.new(false, false).all?.should_equal(false)

      EnumerableSpecs::Numerous.new(nil).all?.should_equal(false)
      EnumerableSpecs::Numerous.new(nil, nil).all?.should_equal(false)

      EnumerableSpecs::Numerous.new(1, nil, 2).all?.should_equal(false)
      EnumerableSpecs::Numerous.new(0, "x", false, true).all?.should_equal(false)
      @enum2.all?.should_equal(false)
    end
  end

  describe "with block" do |it| 
    it.returns "true if the block never returns false or nil" do
      @enum.all? { true }.should_equal(true)
      @enum1.all?{ |o| o < 5 }.should_equal(true)
      @enum1.all?{ |o| 5 }.should_equal(true)
    end

    it.returns "false if the block ever returns false or nil" do
      @enum.all? { false }.should_equal(false)
      @enum.all? { nil }.should_equal(false)
      @enum1.all?{ |o| o > 2 }.should_equal(false)

      EnumerableSpecs::Numerous.new.all? { |i| i > 5 }.should_equal(false)
      EnumerableSpecs::Numerous.new.all? { |i| i == 3 ? nil : true }.should_equal(false)
    end

    it.can "stops iterating once the return value is determined" do
      yielded = []
      EnumerableSpecs::Numerous.new(:one, :two, :three).all? do |e|
        yielded << e
        false
      end.should_equal(false)
      yielded.should_equal([:one])

      yielded = []
      EnumerableSpecs::Numerous.new(true, true, false, true).all? do |e|
        yielded << e
        e
      end.should_equal(false)
      yielded.should_equal([true, true, false])

      yielded = []
      EnumerableSpecs::Numerous.new(1, 2, 3, 4, 5).all? do |e|
        yielded << e
        e
      end.should_equal(true)
      yielded.should_equal([1, 2, 3, 4, 5])
    end

    it.does_not "hide exceptions out of the block" do
      lambda {
        @enum.all? { raise "from block" }
      }.should_raise(RuntimeError, "from block")
    end
  end
end
