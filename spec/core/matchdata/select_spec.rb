# require File.dirname(__FILE__) + '/../../spec_helper'

describe "MatchData#select" do |it| 
  it.yields "the contents of the match array to a block" do
     /(.)(.)(\d+)(\d)/.match("THX1138: The Movie").select { |x| x }.should_equal(["HX1138", "H", "X", "113", "8"])
  end
end
