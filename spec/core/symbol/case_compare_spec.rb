# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Symbol#===" do |it| 
  it.returns "true when the other is a Symbol" do
    (Symbol === :ruby).should_equal(true)
    (Symbol === :"ruby").should_equal(true)
    (Symbol === :'ruby').should_equal(true)
    (Symbol === 'ruby').should_equal(false)
  end
end

# Symbol === :fnord