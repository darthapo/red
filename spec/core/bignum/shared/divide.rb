describe :bignum_divide, :shared => true do
  before(:each) do
    @bignum = bignum_value(88)
  end
  
  it.returns "self divided by other" do
    @bignum.send(@method, 4).should_equal(2305843009213693974)

    @bignum.send(@method, bignum_value(2)).should_be_close(1, TOLERANCE)
    
    (-(10**50)).send(@method, -(10**40 + 1)).should_equal(9999999999)
    (10**50).send(@method, 10**40 + 1).should_equal(9999999999)

    (-10**50).send(@method, 10**40 + 1).should_equal(-10000000000)
    (10**50).send(@method, -(10**40 + 1)).should_equal(-10000000000)
  end

  it.raises " a ZeroDivisionError if other is zero and not a Float" do
    lambda { @bignum.send(@method, 0) }.should_raise(ZeroDivisionError)
  end

  it.raises " a TypeError when given a non-Integer" do
    lambda { @bignum.send(@method, mock('10')) }.should_raise(TypeError)
    lambda { @bignum.send(@method, "2") }.should_raise(TypeError)
    lambda { @bignum.send(@method, :symbol) }.should_raise(TypeError)
  end
end
