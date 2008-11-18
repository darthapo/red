# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Enumerable#zip" do |it| 

  it.can "combines each element of the receiver with the element of the same index in arrays given as arguments" do
    EnumerableSpecs::Numerous.new(1,2,3).zip([4,5,6],[7,8,9]).should_equal([[1,4,7],[2,5,8],[3,6,9]])
    EnumerableSpecs::Numerous.new(1,2,3).zip.should_equal([[1],[2],[3]])
  end
  
  it.will "passe each element of the result array to a block and return nil if a block is given" do
    expected = [[1,4,7],[2,5,8],[3,6,9]]
    EnumerableSpecs::Numerous.new(1,2,3).zip([4,5,6],[7,8,9]) do |result_component|
      result_component.should_equal(expected.shift)
    end.should_equal(nil)
    expected.size.should_equal(0)
  end
  
  it.can "fills resulting array with nils if an argument array is too short" do
    EnumerableSpecs::Numerous.new(1,2,3).zip([4,5,6], [7,8]).should_equal([[1,4,7],[2,5,8],[3,6,nil]])
  end
  
  it.can "convert arguments to arrays using #to_a" do
    convertable = EnumerableSpecs::ArrayConvertable.new(4,5,6)
    EnumerableSpecs::Numerous.new(1,2,3).zip(convertable).should_equal([[1,4],[2,5],[3,6]])
    convertable.called.should_equal(:to_a)
  end

end

