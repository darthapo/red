# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Enumerable#min" do |it| 
  before :each do
    @a = EnumerableSpecs::EachDefiner.new( 2, 4, 6, 8, 10 )

    @e_strs = EnumerableSpecs::EachDefiner.new("333", "22", "666666", "1", "55555", "1010101010")
    @e_ints = EnumerableSpecs::EachDefiner.new( 333,   22,   666666,   55555, 1010101010)
  end

  it.can "min should return the minimum element" do
    EnumerableSpecs::Numerous.new.min.should_equal(1)
  end

  it.returns " the minimun (basic cases)" do
    EnumerableSpecs::EachDefiner.new(55).min.should_equal(55)

    EnumerableSpecs::EachDefiner.new(11,99).min.should_equal( 11)
    EnumerableSpecs::EachDefiner.new(99,11).min.should_equal(11)
    EnumerableSpecs::EachDefiner.new(2, 33, 4, 11).min.should_equal(2)

    EnumerableSpecs::EachDefiner.new(1,2,3,4,5).min.should_equal(1)
    EnumerableSpecs::EachDefiner.new(5,4,3,2,1).min.should_equal(1)
    EnumerableSpecs::EachDefiner.new(4,1,3,5,2).min.should_equal(1)
    EnumerableSpecs::EachDefiner.new(5,5,5,5,5).min.should_equal(5)

    EnumerableSpecs::EachDefiner.new("aa","tt").min.should_equal("aa")
    EnumerableSpecs::EachDefiner.new("tt","aa").min.should_equal("aa")
    EnumerableSpecs::EachDefiner.new("2","33","4","11").min.should_equal("11")

    @e_strs.min.should_equal("1")
    @e_ints.min.should_equal(22)
  end

  it.returns " nil when error" do
    EnumerableSpecs::EachDefiner.new().min.should_equal(nil)
    lambda {
      EnumerableSpecs::EachDefiner.new(Object.new, Object.new).min
    }.should_raise(NoMethodError)
    lambda {
      EnumerableSpecs::EachDefiner.new(11,"22").min
    }.should_raise(ArgumentError)
    lambda {
      EnumerableSpecs::EachDefiner.new(11,12,22,33).min{|a, b| nil}
    }.should_raise(ArgumentError)
  end

  it.returns " the minimun when using a block rule" do
    EnumerableSpecs::EachDefiner.new("2","33","4","11").min {|a,b| a <=> b }.should_equal("11")
    EnumerableSpecs::EachDefiner.new( 2 , 33 , 4 , 11 ).min {|a,b| a <=> b }.should_equal(2)

    EnumerableSpecs::EachDefiner.new("2","33","4","11").min {|a,b| b <=> a }.should_equal("4")
    EnumerableSpecs::EachDefiner.new( 2 , 33 , 4 , 11 ).min {|a,b| b <=> a }.should_equal(33)

    EnumerableSpecs::EachDefiner.new( 1, 2, 3, 4 ).min {|a,b| 15 }.should_equal(1)

    EnumerableSpecs::EachDefiner.new(11,12,22,33).min{|a, b| 2 }.should_equal(11)
    @i = -2
    EnumerableSpecs::EachDefiner.new(11,12,22,33).min{|a, b| @i += 1 }.should_equal(12)

    @e_strs.min {|a,b| a.length <=> b.length }.should_equal("1")

    @e_strs.min {|a,b| a <=> b }.should_equal("1")
    @e_strs.min {|a,b| a.to_i <=> b.to_i }.should_equal("1")

    @e_ints.min {|a,b| a <=> b }.should_equal(22)
    @e_ints.min {|a,b| a.to_s <=> b.to_s }.should_equal(1010101010)
  end

  it.returns "the minimum for enumerables that contain nils" do
    arr = EnumerableSpecs::Numerous.new(nil, nil, true)
    arr.min { |a, b|
      x = a.nil? ? -1 : a ? 0 : 1
      y = b.nil? ? -1 : b ? 0 : 1
      x <=> y
    }.should_equal(nil)
  end
end
