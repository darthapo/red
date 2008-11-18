# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Hash#keys" do |it| 
  it.returns "an array populated with keys" do
    {}.keys.should_equal([])
    {}.keys.class.should_equal(Array)
    Hash.new(5).keys.should_equal([])
    Hash.new { 5 }.keys.should_equal([])
    { 1 => 2, 2 => 4, 4 => 8 }.keys.should_equal([1, 2, 4])
    { 1 => 2, 2 => 4, 4 => 8 }.keys.class.should_equal(Array)
    { nil => nil }.keys.should_equal([nil])
  end

  it.uses "the same order as #values" do
    h = { 1 => "1", 2 => "2", 3 => "3", 4 => "4" }
    
    h.size.times do |i|
      h[h.keys[i]].should_equal(h.values[i])
    end
  end
end
