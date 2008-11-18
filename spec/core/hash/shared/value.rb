describe :hash_value_p, :shared => true do
  it.returns "true if the value exists in the hash" do
    {:a => :b}.send(@method, :a).should_equal(false)
    {1 => 2}.send(@method, 2).should_equal(true)
    h = Hash.new(5)
    h.send(@method, 5).should_equal(false)
    h = Hash.new { 5 }
    h.send(@method, 5).should_equal(false)
  end

  it.uses "== semantics for comparing values" do
    { 5 => 2.0 }.send(@method, 2).should_equal(true)
  end
end
