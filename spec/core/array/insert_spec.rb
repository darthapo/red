# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Array#insert" do |it| 
  it.returns "self" do
    ary = []
    ary.insert(0).should_equal(ary)
    ary.insert(0, :a).should_equal(ary)
  end

  it.can "inserts objects before the element at index for non-negative index" do
    ary = []
    ary.insert(0, 3).should_equal([3])
    ary.insert(0, 1, 2).should_equal([1, 2, 3])
    ary.insert(0).should_equal([1, 2, 3])
    
    # Let's just assume insert() always modifies the array from now on.
    ary.insert(1, 'a').should_equal([1, 'a', 2, 3])
    ary.insert(0, 'b').should_equal(['b', 1, 'a', 2, 3])
    ary.insert(5, 'c').should_equal(['b', 1, 'a', 2, 3, 'c'])
    ary.insert(7, 'd').should_equal(['b', 1, 'a', 2, 3, 'c', nil, 'd'])
    ary.insert(10, 5, 4).should_equal(['b', 1, 'a', 2, 3, 'c', nil, 'd', nil, nil, 5, 4])
  end

  it.can "appends objects to the end of the array for index == -1" do
    [1, 3, 3].insert(-1, 2, 'x', 0.5).should_equal([1, 3, 3, 2, 'x', 0.5])
  end

  it.can "inserts objects after the element at index with negative index" do
    ary = []
    ary.insert(-1, 3).should_equal([3])
    ary.insert(-2, 2).should_equal([2, 3])
    ary.insert(-3, 1).should_equal([1, 2, 3])
    ary.insert(-2, -3).should_equal([1, 2, -3, 3])
    ary.insert(-1, []).should_equal([1, 2, -3, 3, []])
    ary.insert(-2, 'x', 'y').should_equal([1, 2, -3, 3, 'x', 'y', []])
    ary = [1, 2, 3]
  end

  it.can "pads with nils if the index to be inserted to is past the end" do
    [].insert(5, 5).should_equal([nil, nil, nil, nil, nil, 5])
  end

  it.can "can insert before the first element with a negative index" do
    [1, 2, 3].insert(-4, -3).should_equal([-3, 1, 2, 3])
  end  
  
  it.raises " an IndexError if the negative index is out of bounds" do
    lambda { [].insert(-2, 1)  }.should_raise(IndexError)
    lambda { [1].insert(-3, 2) }.should_raise(IndexError)
  end

  it.does_not "hing of no object is passed" do
    [].insert(0).should_equal([])
    [].insert(-1).should_equal([])
    [].insert(10).should_equal([])
    [].insert(-2).should_equal([])
  end

  it.tries "to convert the passed position argument to an Integer using #to_int" do
    obj = mock('2')
    obj.should_receive(:to_int).and_return(2)
    [].insert(obj, 'x').should_equal([nil, nil, 'x'])
  end

  it.checks "whether the passed position argument responds to #to_int" do
    obj = mock('2')
    obj.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_int).and_return(2)
    [].insert(obj, 'x').should_equal([nil, nil, 'x'])
  end

  it 'raises an ArgumentError if no argument passed' do
    lambda { [].insert() }.should_raise(ArgumentError)
  end
end
