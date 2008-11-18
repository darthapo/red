# require File.dirname(__FILE__) + '/../spec_helper'

describe "Hash literal" do |it| 
  it.can "{} should return an empty hash" do
    {}.size.should_equal(0)
    {}.should_equal({})
  end

  it.can "{} should return a new hash populated with the given elements" do
    h = {:a => 'a', 'b' => 3, 44 => 2.3}
    h.size.should_equal(3)
    h.should_equal({:a => "a", "b" => 3, 44 => 2.3})
  end

  it.can "treats empty expressions as nils" do
    h = {() => ()}
    h.keys.should_equal([nil])
    h.values.should_equal([nil])
    h[nil].should_equal(nil)

    h = {() => :value}
    h.keys.should_equal([nil])
    h.values.should_equal([:value])
    h[nil].should_equal(:value)

    h = {:key => ()}
    h.keys.should_equal([:key])
    h.values.should_equal([nil])
    h[:key].should_equal(nil)
  end
end
