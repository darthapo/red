describe :string_to_a, :shared => true do
  it.returns "an empty array for empty strings" do
    "".send(@method).should_equal([])
  end

  it.returns "an array containing the string for non-empty strings" do
    "hello".send(@method).should_equal(["hello"])
  end
end
