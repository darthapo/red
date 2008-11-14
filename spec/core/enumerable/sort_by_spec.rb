# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Enumerable#sort_by" do |it| 
  it.returns "an array of elements ordered by the result of block" do
    a = EnumerableSpecs::Numerous.new("once", "upon", "a", "time")
    a.sort_by { |i| i[0] }.should_equal(["a", "once", "time", "upon"])
  end

  it.can "sorts the object by the given attribute" do
    a = EnumerableSpecs::SortByDummy.new("fooo")
    b = EnumerableSpecs::SortByDummy.new("bar")

    ar = [a, b].sort_by { |d| d.s }
    ar.should_equal([b, a])
  end
end
