describe "Array#to_ary" do |it| 
  it.returns "self" do
    a = [1, 2, 3]
    a.should_equal(a.to_ary)
    a = ArraySpecs::MyArray[1, 2, 3]
    a.should_equal(a.to_ary)
  end

  it.can "properly handle recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    empty.to_ary.should_equal(empty)

    array = ArraySpecs.recursive_array
    array.to_ary.should_equal(array)
  end
end
