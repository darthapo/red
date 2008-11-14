# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/shared/length'

describe "MatchData#length" do |it| 
  it.behaves_like(:matchdata_length, :length)
end
