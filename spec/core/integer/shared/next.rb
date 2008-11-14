describe :integer_next, :shared => true do
  it.returns "the Integer equal to self + 1" do
    0.send(@method).should_equal(1 )
    -1.send(@method).should_equal(0)
    bignum_value.send(@method).should_equal(bignum_value(1))
    20.send(@method).should_equal(21)
  end
end
