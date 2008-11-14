# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Hash#values" do |it| 
  it.returns "an array of values" do
    h = { 1 => :a, 'a' => :a, 'the' => 'lang'}
    h.values.class.should_equal(Array)
    h.values.sort {|a, b| a.to_s <=> b.to_s}.should_equal([:a, :a, 'lang'])
  end
end
