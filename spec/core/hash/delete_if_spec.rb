# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'
# require File.dirname(__FILE__) + '/shared/iteration'

describe "Hash#delete_if" do |it| 
  it.will "yield two arguments: key and value" do
    all_args = []
    {1 => 2, 3 => 4}.delete_if { |*args| all_args << args }
    all_args.should_equal([[1, 2], [3, 4]])
  end
  
  it.can "removes every entry for which block is true and returns self" do
    h = {:a => 1, :b => 2, :c => 3, :d => 4}
    h.delete_if { |k,v| v % 2 == 1 }.should_equal(h)
    h.should_equal({:b => 2, :d => 4})
  end
  
  it.can "processes entries with the same order as each()" do
    h = {:a => 1, :b => 2, :c => 3, :d => 4}

    each_pairs = []
    delete_pairs = []

    h.each_pair { |*pair| each_pairs << pair }
    h.delete_if { |*pair| delete_pairs << pair }

    each_pairs.should_equal(delete_pairs)
  end
  
  it.behaves_like(:hash_iteration_method, :delete_if)
  it.behaves_like(:hash_iteration_no_block, :delete_if)
end
