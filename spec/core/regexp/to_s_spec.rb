# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Regexp#to_s" do |it| 
  it.should "display options if included" do
     /abc/mxi.to_s.should_equal("(?mix:abc)")
   end

   it.should "show non-included options after a - sign" do
     /abc/i.to_s.should_equal("(?i-mx:abc)")
   end

   it.should "show all options as excluded if none are selected" do
     /abc/.to_s.should_equal("(?-mix:abc)")
   end

   it.should "show the pattern after the options" do
     /ab+c/mix.to_s.should_equal("(?mix:ab+c)")
     /xyz/.to_s.should_equal("(?-mix:xyz)")
   end

   it.should "display groups with options" do
     /(?ix:foo)(?m:bar)/.to_s.should_equal("(?-mix:(?ix:foo)(?m:bar))")
     /(?ix:foo)bar/m.to_s.should_equal("(?m-ix:(?ix:foo)bar)")
   end

  it.can "displays single group with same options as main regex as the main regex" do
    /(?i:nothing outside this group)/.to_s.should_equal("(?i-mx:nothing outside this group)")
  end

  it.can "deals properly with uncaptured groups" do
    /whatever(?:0d)/ix.to_s.should_equal("(?ix-m:whatever(?:0d))")
  end

  it.can "deals properly with the two types of lookahead groups" do
    /(?=5)/.to_s.should_equal("(?-mix:(?=5))")
    /(?!5)/.to_s.should_equal("(?-mix:(?!5))")
  end

  it.returns "a string in (?xxx:yyy) notation" do
    /ab+c/ix.to_s.should_equal("(?ix-m:ab+c)")
    /jis/s.to_s.should_equal("(?-mix:jis)")
    /(?i:.)/.to_s.should_equal("(?i-mx:.)")
    /(?:.)/.to_s.should_equal("(?-mix:.)")
  end

  it.can "handle abusive option groups" do
    /(?mmmmix-miiiix:)/.to_s.should_equal('(?-mix:)')
  end

end
