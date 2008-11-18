# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Array#delete_at" do |it| 
  it.can "remove the element at the specified index" do
    a = [1, 2, 3, 4]
    a.delete_at(2)
    a.should_equal([1, 2, 4])
    a.delete_at(-1)
    a.should_equal([1, 2])
  end

  it.returns "the removed element at the specified index" do
    a = [1, 2, 3, 4]
    a.delete_at(2).should_equal(3)
    a.delete_at(-1).should_equal(4)
  end
  
  it.returns "nil and makes no modification if the index is out of range" do
    a = [1, 2]
    a.delete_at(3).should_equal(nil)
    a.should_equal([1, 2])
    a.delete_at(-3).should_equal(nil)
    a.should_equal([1, 2])
  end

  it.tries "to convert the passed argument to an Integer using #to_int" do
    obj = mock('to_int')
    obj.should_receive(:to_int).and_return(-1)
    [1, 2].delete_at(obj).should_equal(2)
  end

  it.checks "whether the passed argument responds to #to_int" do
    obj = mock('method_missing to_int')
    obj.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_int).and_return(-1)
    [1, 2].delete_at(obj).should_equal(2)
  end

  it.will "accepts negative indices" do
    a = [1, 2]
    a.delete_at(-2).should_equal(1)
  end

  it.will "keep tainted status" do
    ary = [1, 2]
    ary.taint
    ary.tainted?.should_be_true
    ary.delete_at(0)
    ary.tainted?.should_be_true
    ary.delete_at(0) # now empty
    ary.tainted?.should_be_true
  end
end
