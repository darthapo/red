# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'
# require File.dirname(__FILE__) + '/shared/iteration'

describe "Hash#each_key" do |it| 
  it.calls " block once for each key, passing key" do
    r = {}
    h = {1 => -1, 2 => -2, 3 => -3, 4 => -4 }
    h.each_key { |k| r[k] = k }.should_equal(h)
    r.should_equal({ 1 => 1, 2 => 2, 3 => 3, 4 => 4 })
  end

  it.can "processes keys in the same order as keys()" do
    keys = []
    h = {1 => -1, 2 => -2, 3 => -3, 4 => -4 }
    h.each_key { |k| keys << k }
    keys.should_equal(h.keys)
  end

  it.behaves_like(:hash_iteration_method, :each_key)
  it.behaves_like(:hash_iteration_modifying, :each_key)
  it.behaves_like(:hash_iteration_no_block, :each_key)
end
