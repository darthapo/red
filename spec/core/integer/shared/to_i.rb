describe :integer_to_i, :shared => true do
  it.returns "self" do
    10.send(@method).should_equal(10)
    (-15).send(@method).should_equal(-15)
    bignum_value.send(@method).should_equal(bignum_value)
    (-bignum_value).send(@method).should_equal(-bignum_value)
  end
end
