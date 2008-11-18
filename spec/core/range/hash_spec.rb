# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Range#hash" do |it| 
  it.is "provided" do
    (0..1).respond_to?(:hash).should_equal(true)
    ('A'..'Z').respond_to?(:hash).should_equal(true)
    (0xfffd..0xffff).respond_to?(:hash).should_equal(true)
    (0.5..2.4).respond_to?(:hash).should_equal(true)
  end
  
  it.will "generate the same hash values for Ranges with the same start, end and exclude_end? values" do
    (0..1).hash.should_equal((0..1).hash)
    (0...10).hash.should_equal((0...10).hash)
    (0..10).hash.should_not == (0...10).hash
  end
end
