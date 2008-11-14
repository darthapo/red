# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Enumerable#each_with_index" do |it| 

  before :each do
    @b = [2, 5, 3, 6, 1, 4]  
  end 
  
  it.will "passe each element and its index to block" do
    @a = []
    EnumerableSpecs::Numerous.new.each_with_index { |o, i| @a << [o, i] }
    @a.should_equal([[2, 0], [5, 1], [3, 2], [6, 3], [1, 4], [4, 5]])
  end
  
  it.can "provide each element to the block" do  
    acc = []
    obj = EnumerableSpecs::EachDefiner.new()
    res = obj.each_with_index {|a,i| acc << [a,i]}
    acc.should_equal([])
    obj.should_equal(res)
  end
  
  it.can "provide each element to the block and its index" do
    acc = [] 
    res = @b.each_with_index {|a,i| acc << [a,i]}
    [[2, 0], [5, 1], [3, 2], [6, 3], [1, 4], [4, 5]].should_equal(acc)
    @b.should_equal(res)
  end

  it.can "binds splat arguments properly" do
    acc = []
    res = @b.each_with_index { |*b| c,d = b; acc << c; acc << d }
    [2, 0, 5, 1, 3, 2, 6, 3, 1, 4, 4, 5].should_equal(acc)
    @b.should_equal(res)
  end
end
