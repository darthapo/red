# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Enumerable#reject" do  |it| 
  it.returns "an array of the elements for which block is false" do
    EnumerableSpecs::Numerous.new.reject { |i| i > 3 }.should_equal([2, 3, 1])
    entries = (1..10).to_a
    numerous = EnumerableSpecs::Numerous.new(*entries)
    numerous.reject {|i| i % 2 == 0 }.should_equal([1,3,5,7,9])
    numerous.reject {|i| true }.should_equal([])
    numerous.reject {|i| false }.should_equal(entries)
  end
end