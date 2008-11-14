describe :fixnum_modulo, :shared => true do
  it.returns "the modulus obtained from dividing self by the given argument" do
    13.send(@method, 4).should_equal(1)
    4.send(@method, 13).should_equal(4)

    13.send(@method, 4.0).should_equal(1)
    4.send(@method, 13.0).should_equal(4)

    1.send(@method, 2.0).should_equal(1.0)
    200.send(@method, bignum_value).should_equal(200)
  end

  it.raises " a ZeroDivisionError when the given argument is 0" do
    lambda { 13.send(@method, 0)  }.should_raise(ZeroDivisionError)
    lambda { 0.send(@method, 0)   }.should_raise(ZeroDivisionError)
    lambda { -10.send(@method, 0) }.should_raise(ZeroDivisionError)
  end

  it.does_not "raise a FloatDomainError when the given argument is 0 and a Float" do
    0.send(@method, 0.0).to_s.should_equal("NaN" )
    10.send(@method, 0.0).to_s.should_equal("NaN" )
    -10.send(@method, 0.0).to_s.should_equal("NaN" )
  end

  it.raises " a TypeError when given a non-Integer" do
    lambda {
      (obj = mock('10')).should_receive(:to_int).any_number_of_times.and_return(10)
      13.send(@method, obj)
    }.should_raise(TypeError)
    lambda { 13.send(@method, "10")    }.should_raise(TypeError)
    lambda { 13.send(@method, :symbol) }.should_raise(TypeError)
  end
end
