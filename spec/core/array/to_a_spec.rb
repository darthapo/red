describe "Array#to_a" do |it| 
  it.returns "self" do
    a = [1, 2, 3]
    a.to_a.should_equal([1, 2, 3])
    a.should_equal(a.to_a) 
  end
  
  it.does_not "return subclass instance on Array subclasses" do
    e = ArraySpecs::MyArray.new
    e << 1
    e.to_a.class.should_equal(Array)
    e.to_a.should_equal([1])
  end

  it.can "properly handle recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    empty.to_a.should_equal(empty)

    array = ArraySpecs.recursive_array
    array.to_a.should_equal(array)
  end
end
