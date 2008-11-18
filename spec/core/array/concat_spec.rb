# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Array#concat" do |it| 
  it.returns "the array itself" do
    ary = [1,2,3]
    ary.concat([4,5,6]).equal?(ary).should_be_true
  end

  it.will "append the elements in the other array" do
    ary = [1, 2, 3]
    ary.concat([9, 10, 11]).should_equal(ary)
    ary.should_equal([1, 2, 3, 9, 10, 11])
    ary.concat([])
    ary.should_equal([1, 2, 3, 9, 10, 11])
  end
  
  it.does_not "loop endlessly when argument is self" do
    ary = ["x", "y"]
    ary.concat(ary).should_equal(["x", "y", "x", "y"])
  end  

  it.tries "to convert the passed argument to an Array using #to_ary" do
    obj = mock('to_ary')
    obj.should_receive(:to_ary).and_return(["x", "y"])
    [4, 5, 6].concat(obj).should_equal([4, 5, 6, "x", "y"])
  end

  it.checks "whether the passed argument responds to #to_ary" do
    obj = mock('method_missing to_ary')
    obj.should_receive(:respond_to?).with(:to_ary).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_ary).and_return([:x])
    [].concat(obj).should_equal([:x])
  end

  it.does_not "call #to_ary on Array subclasses" do
    obj = ArraySpecs::ToAryArray[5, 6, 7]
    obj.should_not_receive(:to_ary)
    [].concat(obj).should_equal([5, 6, 7])
  end
  
  it.will "keep its tainted status" do
    ary = [1, 2]
    ary.taint
    ary.concat([3])
    ary.tainted?.should_be_true
    ary.concat([])
    ary.tainted?.should_be_true
  end

  it.is_not " infected by the other" do
    ary = [1,2]
    other = [3]; other.taint
    ary.tainted?.should_be_false
    ary.concat(other)
    ary.tainted?.should_be_false
  end

  it.will "keep the tainted status of elements" do
    ary = [ Object.new, Object.new, Object.new ]
    ary.each {|x| x.taint }

    ary.concat([ Object.new ])
    ary[0].tainted?.should_be_true
    ary[1].tainted?.should_be_true
    ary[2].tainted?.should_be_true
    ary[3].tainted?.should_be_false
  end
end
