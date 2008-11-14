describe "Array.allocate" do |it|
  it.returns "an instance of Array" do
    ary = Array.allocate
    ary.should_be_kind_of(Array)
  end
  
  it.returns "a fully-formed instance of Array" do
    ary = Array.allocate
    ary.size.should_equal(0)
    ary << 1
    ary.should_equal([1])
  end
  
  it.does_not "accept any arguments" do
    lambda { Array.allocate(1) }.should_raise(ArgumentError)
  end
end
