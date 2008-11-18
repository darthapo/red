# require File.dirname(__FILE__) + '/../../spec_helper'

describe "MatchData#captures" do |it| 
  it.returns "an array of the match captures" do
    /(.)(.)(\d+)(\d)/.match("THX1138.").captures.should_equal(["H","X","113","8"])
  end
end
