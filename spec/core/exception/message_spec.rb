# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Exception#message" do |it| 
  it.returns "the exception message" do
    [Exception.new.message, Exception.new("Ouch!").message].should_equal(["Exception", "Ouch!"])
  end  
end
