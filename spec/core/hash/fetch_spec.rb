# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Hash#fetch" do |it| 
  it.returns "the value for key" do
    { :a => 1, :b => -1 }.fetch(:b).should_equal(-1)
  end
  
  it.raises " an IndexError if key is not found" do
    lambda { {}.fetch(:a)             }.should_raise(IndexError)
    lambda { Hash.new(5).fetch(:a)    }.should_raise(IndexError)
    lambda { Hash.new { 5 }.fetch(:a) }.should_raise(IndexError)
  end
  
  it.returns "default if key is not found when passed a default" do
    {}.fetch(:a, nil).should_equal(nil)
    {}.fetch(:a, 'not here!').should_equal("not here!")
    { :a => nil }.fetch(:a, 'not here!').should_equal(nil)
  end
  
  it.returns "value of block if key is not found when passed a block" do
    {}.fetch('a') { |k| k + '!' }.should_equal("a!")
  end

  it.can "gives precedence to the default block over the default argument when passed both" do
    {}.fetch(9, :foo) { |i| i * i }.should_equal(81)
  end

  it.raises " an ArgumentError when not passed one or two arguments" do
    lambda { {}.fetch()        }.should_raise(ArgumentError)
    lambda { {}.fetch(1, 2, 3) }.should_raise(ArgumentError)
  end
end
