# require File.dirname(__FILE__) + '/../../spec_helper'

describe "MatchData#offset" do |it| 
  it.returns "a two element array with the begin and end of the nth match" do
    /(.)(.)(\d+)(\d)/.match("THX1138.").offset(0).should_equal([1, 7])
    /(.)(.)(\d+)(\d)/.match("THX1138.").offset(4).should_equal([6, 7])
  end
end
