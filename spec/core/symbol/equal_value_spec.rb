# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Symbol#==" do |it| 
  it.will "only return true when the other is exactly the same symbol" do
    (:ruby == :ruby).should_equal(true)
    (:ruby == :"ruby").should_equal(true)
    (:ruby == :'ruby').should_equal(true)
    (:@ruby == :@ruby).should_equal(true)
    
    (:ruby == :@ruby).should_equal(false)
    (:foo == :bar).should_equal(false)
    (:ruby == 'ruby').should_equal(false)
  end
end
