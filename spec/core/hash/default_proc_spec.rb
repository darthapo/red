# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Hash#default_proc" do |it| 
  it.returns "the block passed to Hash.new" do
    h = Hash.new { |i| 'Paris' }
    p = h.default_proc
    p.call(1).should_equal('Paris')
  end
  
  it.returns "nil if no block was passed to proc" do
    Hash.new.default_proc.should_equal(nil)
  end
end
