# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Hash#shift" do |it| 
  it.will "remove a pair from hash and return it (same order as to_a)" do
    h = { :a => 1, :b => 2, "c" => 3, nil => 4, [] => 5 }
    pairs = h.to_a

    h.size.times do
      r = h.shift
      r.class.should_equal(Array)
      r.should_equal(pairs.shift)
      h.size.should_equal(pairs.size)
    end

    h.should_equal({})
  end

  it.returns "nil from an empty hash " do
    {}.shift.should_equal(nil)
  end

  it.returns "(computed) default for empty hashes" do
    Hash.new(5).shift.should_equal(5)
    h = Hash.new { |*args| args }
    h.shift.should_equal([h, nil])
  end
end
