# require File.dirname(__FILE__) + '/../../spec_helper'

describe "MatchData#post_match" do |it| 
  it.returns "the string after the match equiv. special var $'" do
    /(.)(.)(\d+)(\d)/.match("THX1138: The Movie").post_match.should_equal(': The Movie' )
    $'.should_equal(': The Movie')
  end
end
