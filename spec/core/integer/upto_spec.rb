# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Integer#upto [stop] when self and stop are Fixnums" do |it| 
  it.does_not "yield when stop is less than self" do
    result = []
    5.upto(4) { |x| result << x }
    result.should_equal([])
  end
  
  it.yields "once when stop equals self" do
    result = []
    5.upto(5) { |x| result << x }
    result.should_equal([5])
  end
  
  it.yields "while increasing self until it is less than stop" do
    result = []
    2.upto(5) { |x| result << x }
    result.should_equal([2, 3, 4, 5])
  end

  it.yields "while increasing self until it is greater than floor of a Float endpoint" do
    result = []
    9.upto(13.3) {|i| result << i}
    -5.upto(-1.3) {|i| result << i}
    result.should_equal([9,10,11,12,13,-5,-4,-3,-2] )
  end 

  it.raises " an ArgumentError for non-numeric endpoints" do
    lambda { 1.upto("A") {|x| p x} }.should_raise(ArgumentError) 
    lambda { 1.upto(nil) {|x| p x} }.should_raise(ArgumentError)
  end
end
