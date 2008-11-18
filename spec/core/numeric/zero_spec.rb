# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Numeric#zero?" do |it| 
  it.before(:each) do
    @obj = NumericSub.new
  end
  
  it.returns "true if self is 0" do
    @obj.should_receive(:==).with(0).and_return(true)
    @obj.zero?.should_equal(true)
  end
  
  it.returns "false if self is not 0" do
    @obj.should_receive(:==).with(0).and_return(false)
    @obj.zero?.should_equal(false)
  end
end
