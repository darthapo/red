# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe :hash_values_at, :shared => true do
  it.returns "an array of values for the given keys" do
    h = {:a => 9, :b => 'a', :c => -10, :d => nil}
    h.send(@method).class.should_equal(Array)
    h.send(@method).should_equal([])
    h.send(@method, :a, :d, :b).class.should_equal(Array)
    h.send(@method, :a, :d, :b).should_equal([9, nil, 'a'])
  end
end

describe "Hash#values_at" do |it| 
  it.behaves_like(:hash_values_at, :values_at)
end