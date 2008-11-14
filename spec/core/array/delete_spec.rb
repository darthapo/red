# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Array#delete" do |it| 
  it.can "removes elements that are #== to object" do
    x = mock('delete')
    def x.==(other) 3 == other end

    a = [1, 2, 3, x, 4, 3, 5, x]
    a.delete mock('not contained')
    a.should_equal([1, 2, 3, x, 4, 3, 5, x])

    a.delete 3
    a.should_equal([1, 2, 4, 5])
  end

  it.returns "object or nil if no elements match object" do
    [1, 2, 4, 5].delete(1).should_equal(1)
    [1, 2, 4, 5].delete(3).should_equal(nil)
  end

  it.can "may be given a block that is executed if no element matches object" do
    [1].delete(1) {:not_found}.should_equal(1)
    [].delete('a') {:not_found}.should_equal(:not_found)
  end
  
  it.will "keep tainted status" do
    a = [1, 2]
    a.taint
    a.tainted?.should_be_true
    a.delete(2)
    a.tainted?.should_be_true
    a.delete(1) # now empty
    a.tainted?.should_be_true
  end
end
