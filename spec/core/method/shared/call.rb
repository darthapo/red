describe :method_call, :shared => true do
  it.will "invoke the method with the specified arguments, returning the method's return value" do
    m = 12.method("+")
    m.send(@method, 3).should_equal(15)
    m.send(@method, 20).should_equal(32)
  end

  it.raises " an ArgumentError when given incorrect number of arguments" do
    lambda {
      MethodSpecs::Methods.new.method(:two_req).send(@method, 1, 2, 3)
    }.should_raise(ArgumentError)
    lambda {
      MethodSpecs::Methods.new.method(:two_req).send(@method, 1)
    }.should_raise(ArgumentError)
  end
end
