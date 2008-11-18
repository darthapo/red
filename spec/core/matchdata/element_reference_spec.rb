# require File.dirname(__FILE__) + '/../../spec_helper'

describe "MatchData#[]" do |it| 
  it.will "act as normal array indexing [index]" do
    /(.)(.)(\d+)(\d)/.match("THX1138.")[0].should_equal('HX1138')
    /(.)(.)(\d+)(\d)/.match("THX1138.")[1].should_equal('H')
    /(.)(.)(\d+)(\d)/.match("THX1138.")[2].should_equal('X')
  end

  it.can "support accessors [start, length]" do
    /(.)(.)(\d+)(\d)/.match("THX1138.")[1, 2].should_equal(%w|H X|)
    /(.)(.)(\d+)(\d)/.match("THX1138.")[-3, 2].should_equal(%w|X 113|)
  end

  it.can "support ranges [start..end]" do
    /(.)(.)(\d+)(\d)/.match("THX1138.")[1..3].should_equal(%w|H X 113|)
  end
end
