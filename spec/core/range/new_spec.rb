# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Range.new" do |it| 
  it.will "construct a range using the given start and end" do
    range = Range.new('a', 'c')
    range.should_equal(('a'..'c'))
    
    range.first.should_equal('a')
    range.last.should_equal('c')
  end
  
  it.will "include the end object when the third parameter is omitted or false" do
    Range.new('a', 'c').to_a.should_equal(['a', 'b', 'c'])
    Range.new(1, 3).to_a.should_equal([1, 2, 3])
    
    Range.new('a', 'c', false).to_a.should_equal(['a', 'b', 'c'])
    Range.new(1, 3, false).to_a.should_equal([1, 2, 3])
    
    Range.new('a', 'c', true).to_a.should_equal(['a', 'b'])
    Range.new(1, 3, 1).to_a.should_equal([1, 2])
    
    Range.new(1, 3, mock('[1,2]')).to_a.should_equal([1, 2])
    Range.new(1, 3, :test).to_a.should_equal([1, 2])
  end
  
  it.raises " an ArgumentError when the given start and end can't be compared by using #<=>" do
    lambda { Range.new(1, mock('x'))         }.should_raise(ArgumentError)
    lambda { Range.new(mock('x'), mock('y')) }.should_raise(ArgumentError)
    
    b = mock('x')
    (a = mock('nil')).should_receive(:method_missing).with(:<=>, b).and_return(nil)
    lambda { Range.new(a, b) }.should_raise(ArgumentError)
  end
end
