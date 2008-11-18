describe :array_length, :shared => true do
  it.returns "the number of elements" do
    [].send(@method).should_equal(0)
    [1, 2, 3].send(@method).should_equal(3)
  end

  it.can "properly handles recursive arrays" do
    ArraySpecs.empty_recursive_array.send(@method).should_equal(1)
    ArraySpecs.recursive_array.send(@method).should_equal(8)
  end
end
