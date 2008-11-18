# require File.dirname(__FILE__) + '/../../spec_helper'

describe "MatchData#string" do |it| 
  it.returns "a copy of the match string" do
    str = /(.)(.)(\d+)(\d)/.match("THX1138.").string
    str.should_equal("THX1138.")
  end
end
