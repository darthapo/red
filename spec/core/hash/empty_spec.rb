# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Hash#empty?" do |it| 
  it.returns "true if the hash has no entries" do
    {}.empty?.should_equal(true)
    {1 => 1}.empty?.should_equal(false)
  end

  it.returns "true if the hash has no entries and has a default value" do
    Hash.new(5).empty?.should_equal(true)
    Hash.new { 5 }.empty?.should_equal(true)
    Hash.new { |hsh, k| hsh[k] = k }.empty?.should_equal(true)
  end
end
