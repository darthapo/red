describe "Array#to_s" do |i|
  it.will "be equivalent to #join without a separator string" do
    old = $,
    begin
      a = [1, 2, 3, 4]
      a.to_s.should_equal(a.join)
      $, = '-'
      a.to_s.should_equal(a.join)
    ensure
      $, = old
    end
  end

  it.should "properly handle recursive arrays" do
    ArraySpecs.empty_recursive_array.to_s.should_equal("[...]")
    a = [1, 2, 3]; a << a
    a.to_s.should_equal("123123[...]")
  end
end
