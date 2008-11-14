describe :range_end, :shared => true do
  it.will "end return the last element of self" do
    (-1..1).send(@method).should_equal(1)
    (0..1).send(@method).should_equal(1)
    ("A".."Q").send(@method).should_equal("Q")
    ("A"..."Q").send(@method).should_equal("Q")
    (0xffff...0xfffff).send(@method).should_equal(1048575)
    (0.5..2.4).send(@method).should_equal(2.4)
  end
end
