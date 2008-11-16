# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Numeric#nonzero?" do  |it| 
  it.before(:each) do
    @obj = NumericSub.new
  end
  
  it.returns "self if self#zero? is false" do
    @obj.should_receive(:zero?).and_return(false)
    @obj.nonzero?.should_equal(@obj)
  end
  
  it.returns "nil if self#zero? is true" do
    @obj.should_receive(:zero?).and_return(true)
    @obj.nonzero?.should_equal(nil)
  end
end
