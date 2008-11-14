describe "Array#zip" do |it|
  it.returns "an array of arrays containing corresponding elements of each array" do
    [1, 2, 3, 4].zip(["a", "b", "c", "d", "e"]).should_equal([[1, "a"], [2, "b"], [3, "c"], [4, "d"]])
  end
  
  it.can "fill in missing values with nil" do
    [1, 2, 3, 4, 5].zip(["a", "b", "c", "d"]).should_equal([[1, "a"], [2, "b"], [3, "c"], [4, "d"], [5, nil]])
  end

  it.will "properly handles recursive arrays" do
    a = []; a << a
    b = [1]; b << b

    a.zip(a).should_equal([ [a[0], a[0]] ])
    a.zip(b).should_equal([ [a[0], b[0]] ])
    b.zip(a).should_equal([ [b[0], a[0]], [b[1], a[1]] ])
    b.zip(b).should_equal([ [b[0], b[0]], [b[1], b[1]] ])
  end
  
  it.will "call the block if supplied" do
    values = []
    [1, 2, 3, 4].zip(["a", "b", "c", "d", "e"]) { |value|
      values << value
    }.should_equal(nil)
    
    values.should_equal([[1, "a"], [2, "b"], [3, "c"], [4, "d"]])
  end
  
  # it.does_not "return subclass instance on Array subclasses" do
  #   ArraySpecs::MyArray[1, 2, 3].zip(["a", "b"]).class.should_equal(Array)
  # end
end
