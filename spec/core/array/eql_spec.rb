# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Array#eql?" do |it| 
  it.returns "true if other is the same array" do
    a = [1]
    a.should_equal(a)
  end

  it.returns "true if other has the same length and each pair of corresponding elements are eql" do
    a = [1, 2, 3, 4]
    b = [1, 2, 3, 4]
    a.should_equal(b)
    [].should_equal([])
  end

  it.returns "false if other is shorter than self" do
    a = [1, 2, 3, 4]
    b = [1, 2, 3]
    a.should_not eql(b)
  end

  it.returns "false if other is longer than self" do
    a = [1, 2, 3, 4]
    b = [1, 2, 3, 4, 5]
    a.should_not eql(b)
  end

  it.returns "false when each pair of corresponding elements are equivalent in the sense of == but not in the sense of eql?" do
    a = [1, 2, 3, 4]
    b = [1, 2, 3, 4.0]
    a.should_equal(b)
    a.should_not eql(b)

    obj = mock('what is eql to any object')
    def obj.eql?(x); true end
    c = [obj, obj, obj, obj]
    c.should_equal(a)
  end
  
  it.can "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    empty2 = []; empty2 << empty2
    empty.should_equal(empty.dup)
    empty.should_not eql(empty2)

    array = ArraySpecs.recursive_array
    array.should_equal(array)
    array.should_equal(array.dup)

    array.should_not eql(empty)
    array.should_not eql([1, 2])
  end

  it.will "ignore array class differences" do
    ArraySpecs::MyArray[1, 2, 3].should_equal([1, 2, 3])
    ArraySpecs::MyArray[1, 2, 3].should_equal(ArraySpecs::MyArray[1, 2, 3])
    [1, 2, 3].should_equal(ArraySpecs::MyArray[1, 2, 3])
  end
end
