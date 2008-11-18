describe :string_length, :shared => true do
  it.returns "the length of self" do
    "".send(@method).should_equal(0)
    "\x00".send(@method).should_equal(1)
    "one".send(@method).should_equal(3)
    "two".send(@method).should_equal(3)
    "three".send(@method).should_equal(5)
    "four".send(@method).should_equal(4)
  end
end
