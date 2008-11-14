# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Regexp.union" do |it| 
  it.returns "/(?!)/ when passed no arguments" do
    Regexp.union.should_equal(/(?!)/)
  end
  
  it.returns "a regular expression that will match passed arguments" do
    Regexp.union("penzance").should_equal(/penzance/)
    Regexp.union("skiing", "sledding").should_equal(/skiing|sledding/)
    Regexp.union(/dogs/, /cats/i).should_equal(/(?-mix:dogs)|(?i-mx:cats)/)
  end
end
