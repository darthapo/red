# require File.dirname(__FILE__) + '/../../spec_helper'

describe "MatchData#end" do |it| 
  it.returns "the offset of the end of the nth element" do
    /(.)(.)(\d+)(\d)/.match("THX1138.").end(0).should_equal(7)
    /(.)(.)(\d+)(\d)/.match("THX1138.").end(2).should_equal(3 )
  end
end
