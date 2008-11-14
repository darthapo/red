# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'
# require File.dirname(__FILE__) + '/shared/iteration'

describe "Hash#select" do |it| 
  before(:each) do
    @hsh = {1 => 2, 3 => 4, 5 => 6}
    @empty = {}
  end

  it.yields "two arguments: key and value" do
    all_args = []
    {1 => 2, 3 => 4}.select { |*args| all_args << args }
    all_args.sort.should_equal([[1, 2], [3, 4]])
  end

  it.returns "an array of entries for which block is true" do
    a_pairs = { 'a' => 9, 'c' => 4, 'b' => 5, 'd' => 2 }.select { |k,v| v % 2 == 0 }
    a_pairs.sort.should_equal([['c', 4], ['d', 2]])
  end

  it.can "process entries with the same order as reject" do
    h = { :a => 9, :c => 4, :b => 5, :d => 2 }

    select_pairs = []
    reject_pairs = []
    h.dup.select { |*pair| select_pairs << pair }
    h.reject { |*pair| reject_pairs << pair }

    select_pairs.should_equal(reject_pairs)
  end

  it.behaves_like(:hash_iteration_method, :select)
  it.behaves_like(:hash_iteration_modifying, :select)
end
