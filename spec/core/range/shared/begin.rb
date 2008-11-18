describe :range_begin, :shared => true do
  it.returns "the first element of self" do
    (-1..1).send(@method).should_equal(-1)
    (0..1).send(@method).should_equal(0)
    (0xffff...0xfffff).send(@method).should_equal(65535)
    ('Q'..'T').send(@method).should_equal('Q')
    ('Q'...'T').send(@method).should_equal('Q')
    (0.5..2.4).send(@method).should_equal(0.5)
  end
end
