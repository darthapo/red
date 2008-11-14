# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Regexp#hash" do |it| 
  it.is "provided" do
    Regexp.new('').respond_to?(:hash).should_equal(true)
  end

  it.is "based on the text and options of Regexp" do
    (/cat/ix.hash == /cat/ixn.hash).should_equal(true)
    (/dog/m.hash  == /dog/m.hash).should_equal(true)
    (/cat/.hash   == /cat/ix.hash).should_equal(false)
    (/cat/.hash   == /dog/.hash).should_equal(false)
  end
end
