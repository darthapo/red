describe :proc_dup, :shared => true do
  it.returns "a copy of self" do
    a = lambda { "hello" }
    b = a.send(@method)

    a.should_not equal(b)

    a.call.should_equal(b.call)
  end
end
