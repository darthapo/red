# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Array#hash" do |it| 
  it.returns "the same fixnum for arrays with the same content" do
    [].respond_to?(:hash).should_equal(true)
    
    [[], [1, 2, 3]].each do |ary|
      ary.hash.should_equal(ary.dup.hash)
      ary.hash.class.should_equal(Fixnum)
    end
  end

  it.can "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    empty.hash.should_be_kind_of(Integer)

    array = ArraySpecs.recursive_array
    array.hash.should_be_kind_of(Integer)
  end
  
  it.will "ignore array class differences" do
    ArraySpecs::MyArray[].hash.should_equal([].hash)
    ArraySpecs::MyArray[1, 2].hash.should_equal([1, 2].hash)
  end

  it.returns "same hash code for arrays with the same content" do
    a = [1, 2, 3, 4]
    a.fill 'a', 0..3
    b = %w|a a a a|
    a.hash.should_equal(b.hash)
  end
  
  it.returns "the same value if arrays are #eql?" do
    a = [1, 2, 3, 4]
    a.fill 'a', 0..3
    b = %w|a a a a|
    a.hash.should_equal(b.hash)
    a.should_equal(b)
  end
end
