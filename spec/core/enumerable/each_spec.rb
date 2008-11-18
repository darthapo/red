# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Enumerable.each" do     |it| 
  it.is "provided" do
    EnumerableSpecs::Numerous.new.respond_to?(:each).should_equal(true)
  end
  
  it.can "provide each element to the block" do 
    @b=[]
    EnumerableSpecs::Numerous.new.each { |i| @b << i }
    @b.should_equal([2, 5, 3, 6, 1, 4])
  end 
end
