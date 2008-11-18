# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Hash#sort" do |it| 
  it.can "convert self to a nested array of [key, value] arrays and sort with Array#sort" do
    { 'a' => 'b', '1' => '2', 'b' => 'a' }.sort.should_equal([["1", "2"], ["a", "b"], ["b", "a"]])
  end
  
  it.will "work when some of the keys are themselves arrays" do
    { [1,2] => 5, [1,1] => 5 }.sort.should_equal([[[1,1],5], [[1,2],5]])
  end
  
  it.uses "block to sort array if passed a block" do
    { 1 => 2, 2 => 9, 3 => 4 }.sort { |a,b| b <=> a }.should_equal([[3, 4], [2, 9], [1, 2]])
  end
end
