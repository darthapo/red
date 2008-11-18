# require File.dirname(__FILE__) + '/../../spec_helper'

describe "MatchData#pre_match" do |it| 
  it.returns "the string before the match, equiv. special var $`" do
    /(.)(.)(\d+)(\d)/.match("THX1138: The Movie").pre_match.should_equal('T')
    $`.should_equal('T')
  end
end
