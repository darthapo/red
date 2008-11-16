# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Enumerable#grep" do |it| 
  it.before(:each) do
    @a = EnumerableSpecs::EachDefiner.new( 2, 4, 6, 8, 10)
  end
  
  it.can "grep without a block should return an array of all elements === pattern" do
    class EnumerableSpecGrep; def ===(obj); obj == '2'; end; end

    EnumerableSpecs::Numerous.new('2', 'a', 'nil', '3', false).grep(EnumerableSpecGrep.new).should_equal(['2'])
  end
  
  it.can "grep with a block should return an array of elements === pattern passed through block" do
    class EnumerableSpecGrep2; def ===(obj); /^ca/ =~ obj; end; end

    EnumerableSpecs::Numerous.new("cat", "coat", "car", "cadr", "cost").grep(EnumerableSpecGrep2.new) { |i| i.upcase }.should_equal(["CAT", "CAR", "CADR"])
  end 
  
  it.can "grep the enumerable (rubycon legacy)" do 
    EnumerableSpecs::EachDefiner.new().grep(1).should_equal([])
    @a.grep(3..7).should_equal([4,6])
    @a.grep(3..7) {|a| a+1}.should_equal([5,7])
  end
end
