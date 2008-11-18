# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Enumerable#partition" do |it| 
  it.returns "two arrays, the first containing elements for which the block is true, the second containing the rest" do
    EnumerableSpecs::Numerous.new.partition { |i| i % 2 == 0 }.should_equal([[2, 6, 4], [5, 3, 1]])
  end
end