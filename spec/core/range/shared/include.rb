describe :range_include, :shared => true do
  it.returns "true if other is an element of self" do
    (0..5).send(@method, 2).should_equal(true)
    (-5..5).send(@method, 0).should_equal(true)
    (-1...1).send(@method, 10.5).should_equal(false)
    (-10..-2).send(@method, -2.5).should_equal(true)
    ('C'..'X').send(@method, 'M').should_equal(true)
    ('C'..'X').send(@method, 'A').should_equal(false)
    ('B'...'W').send(@method, 'W').should_equal(false)
    ('B'...'W').send(@method, 'Q').should_equal(true)
    (0xffff..0xfffff).send(@method, 0xffffd).should_equal(true)
    (0xffff..0xfffff).send(@method, 0xfffd).should_equal(false)
    (0.5..2.4).send(@method, 2).should_equal(true)
    (0.5..2.4).send(@method, 2.5).should_equal(false)
    (0.5..2.4).send(@method, 2.4).should_equal(true)
    (0.5...2.4).send(@method, 2.4).should_equal(false)
  end
end
