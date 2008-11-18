# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Hash#initialize" do |it| 
  it.is "private" do
    {}.private_methods.map { |m| m.to_s }.include?("initialize").should_equal(true)
  end

  it.can "can be used to reset default_proc" do
    h = { "foo" => 1, "bar" => 2 }
    h.default_proc.should_equal(nil)
    h.instance_eval { initialize { |h, k| k * 2 } }
    h.default_proc.should_not == nil
    h["a"].should_equal("aa")
  end

  it.should "get passed whatever args were passed to Hash#new" do
    NewHash.new(:one, :two)[0].should_equal(:one)
    NewHash.new(:one, :two)[1].should_equal(:two)
  end
end
