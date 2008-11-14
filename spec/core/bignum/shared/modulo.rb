describe :bignum_modulo, :shared => true do
  before(:each) do
    @bignum = bignum_value
  end
  
  it.returns "the modulus obtained from dividing self by the given argument" do
    @bignum.send(@method, 5).should_equal(3)
    @bignum.send(@method, -5).should_equal(-2)
    @bignum.send(@method, -100).should_equal(-92)
    @bignum.send(@method, 2.22).should_be_close(0.780180180180252, TOLERANCE)
    @bignum.send(@method, bignum_value(10)).should_equal(9223372036854775808)
  end

  it.raises " a ZeroDivisionError when the given argument is 0" do
    lambda { @bignum.send(@method, 0) }.should_raise(ZeroDivisionError)
    lambda { (-@bignum).send(@method, 0) }.should_raise(ZeroDivisionError)
  end

  it.does_not "raise a FloatDomainError when the given argument is 0 and a Float" do
    @bignum.send(@method, 0.0).to_s.should_equal("NaN" )
    (-@bignum).send(@method, 0.0).to_s.should_equal("NaN" )
  end

  it.raises " a TypeError when given a non-Integer" do
    lambda { @bignum.send(@method, mock('10')) }.should_raise(TypeError)
    lambda { @bignum.send(@method, "10") }.should_raise(TypeError)
    lambda { @bignum.send(@method, :symbol) }.should_raise(TypeError)
  end
end
