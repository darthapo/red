# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Exception#inspect" do |it| 
  it.returns "'#<Exception: Exception>' when no message given" do
    Exception.new.inspect.should_equal("#<Exception: Exception>")
  end
  
  it.can "includes message when given" do
    [Exception.new("foobar").inspect].should_equal(["#<Exception: foobar>"])
  end
end
