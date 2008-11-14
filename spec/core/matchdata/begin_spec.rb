# require File.dirname(__FILE__) + '/../../spec_helper'

describe "MatchData#begin" do |it| 
  it.returns "the offset of the start of the nth element" do
    /(.)(.)(\d+)(\d)/.match("THX1138.").begin(0).should_equal(1)
    /(.)(.)(\d+)(\d)/.match("THX1138.").begin(2).should_equal(2)
  end
end
