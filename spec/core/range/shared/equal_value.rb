describe :range_eql, :shared => true do
  it.returns "true if other has same begin, end, and exclude_end? values" do
    (0..2).send(@method, 0..2).should_equal(true)
    ('G'..'M').send(@method,'G'..'M').should_equal(true)
    (0.5..2.4).send(@method, 0.5..2.4).should_equal(true)
    (5..10).send(@method, Range.new(5,10)).should_equal(true)
    ('D'..'V').send(@method, Range.new('D','V')).should_equal(true)
    (0.5..2.4).send(@method, Range.new(0.5, 2.4)).should_equal(true)
    (0xffff..0xfffff).send(@method, 0xffff..0xfffff).should_equal(true)
    (0xffff..0xfffff).send(@method, Range.new(0xffff,0xfffff)).should_equal(true)


    ('Q'..'X').send(@method, 'A'..'C').should_equal(false)
    ('Q'...'X').send(@method, 'Q'..'W').should_equal(false)
    ('Q'..'X').send(@method, 'Q'...'X').should_equal(false)
    (0.5..2.4).send(@method, 0.5...2.4).should_equal(false)
    (1482..1911).send(@method, 1482...1911).should_equal(false)
    (0xffff..0xfffff).send(@method, 0xffff...0xfffff).should_equal(false)
  end

  it.returns "false if other is no Range" do
    (1..10).send(@method, 1).should_equal(false)
    (1..10).send(@method, 'a').should_equal(false)
    (1..10).send(@method, mock('x')).should_equal(false)
  end
end
