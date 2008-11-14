# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Enumerable#max" do |it| 
  before :each do
    @a = EnumerableSpecs::EachDefiner.new( 2, 4, 6, 8, 10 )

    @e_strs = EnumerableSpecs::EachDefiner.new("333", "22", "666666", "1", "55555", "1010101010")
    @e_ints = EnumerableSpecs::EachDefiner.new( 333,   22,   666666,   55555, 1010101010)
  end

  it.can "max should return the maximum element" do
    EnumerableSpecs::Numerous.new.max.should_equal(6)
  end

  it.returns " the maximum element (basics cases)" do
    EnumerableSpecs::EachDefiner.new(55).max.should_equal(55)

    EnumerableSpecs::EachDefiner.new(11,99).max.should_equal(99)
    EnumerableSpecs::EachDefiner.new(99,11).max.should_equal(99)
    EnumerableSpecs::EachDefiner.new(2, 33, 4, 11).max.should_equal(33)

    EnumerableSpecs::EachDefiner.new(1,2,3,4,5).max.should_equal(5)
    EnumerableSpecs::EachDefiner.new(5,4,3,2,1).max.should_equal(5)
    EnumerableSpecs::EachDefiner.new(1,4,3,5,2).max.should_equal(5)
    EnumerableSpecs::EachDefiner.new(5,5,5,5,5).max.should_equal(5)

    EnumerableSpecs::EachDefiner.new("aa","tt").max.should_equal("tt")
    EnumerableSpecs::EachDefiner.new("tt","aa").max.should_equal("tt")
    EnumerableSpecs::EachDefiner.new("2","33","4","11").max.should_equal("4")

    @e_strs.max.should_equal("666666")
    @e_ints.max.should_equal(1010101010)
  end

  it.returns " an error when introduce the wrong kind or number of parameters " do
    # error cases
    EnumerableSpecs::EachDefiner.new().max.should_equal(nil)
    lambda {
      EnumerableSpecs::EachDefiner.new(Object.new, Object.new).max
    }.should_raise(NoMethodError)
    lambda {
      EnumerableSpecs::EachDefiner.new(11,"22").max
    }.should_raise(ArgumentError)
    lambda {
      EnumerableSpecs::EachDefiner.new(11,12,22,33).max{|a, b| nil}
    }.should_raise(ArgumentError)
  end

  it.returns " the maximum element (with block" do
    # with a block
    EnumerableSpecs::EachDefiner.new("2","33","4","11").max {|a,b| a <=> b }.should_equal("4")
    EnumerableSpecs::EachDefiner.new( 2 , 33 , 4 , 11 ).max {|a,b| a <=> b }.should_equal(33)

    EnumerableSpecs::EachDefiner.new("2","33","4","11").max {|a,b| b <=> a }.should_equal("11")
    EnumerableSpecs::EachDefiner.new( 2 , 33 , 4 , 11 ).max {|a,b| b <=> a }.should_equal(2)

    @e_strs.max {|a,b| a.length <=> b.length }.should_equal("1010101010")

    @e_strs.max {|a,b| a <=> b }.should_equal("666666")
    @e_strs.max {|a,b| a.to_i <=> b.to_i }.should_equal("1010101010")

    @e_ints.max {|a,b| a <=> b }.should_equal(1010101010)
    @e_ints.max {|a,b| a.to_s <=> b.to_s }.should_equal(666666)
  end

  it.returns "the minimum for enumerables that contain nils" do
    arr = EnumerableSpecs::Numerous.new(nil, nil, true)
    arr.max { |a, b|
      x = a.nil? ? 1 : a ? 0 : -1
      y = b.nil? ? 1 : b ? 0 : -1
      x <=> y
    }.should_equal(nil)
  end
end
