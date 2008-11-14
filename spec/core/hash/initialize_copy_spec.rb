# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'
# require File.dirname(__FILE__) + '/shared/replace'

describe "Hash#initialize_copy" do |it| 
  it.is "private" do
    {}.private_methods.map { |m| m.to_s }.include?("initialize_copy").should_equal(true)
  end

  it.behaves_like(:hash_replace, :initialize_copy)
end
