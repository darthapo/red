# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Range#to_s" do |it| 
  it.can "provide a printable form of self" do
    (0..21).to_s.should_equal("0..21")
    (-8..0).to_s.should_equal( "-8..0")
    (-411..959).to_s.should_equal("-411..959")
    ('A'..'Z').to_s.should_equal('A..Z')
    ('A'...'Z').to_s.should_equal('A...Z')
    (0xfff..0xfffff).to_s.should_equal("4095..1048575")
    (0.5..2.4).inspect.should_equal("0.5..2.4")
  end
end
