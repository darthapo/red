# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Numeric#remainder" do |it| 
  before(:each) do
    @obj    = NumericSub.new
    @result = mock("Numeric#% result")
    @other  = mock("Passed Object")
  end

  it.returns "the result of calling self#% with other if self is 0" do
    @obj.should_receive(:%).with(@other).and_return(@result)
    @result.should_receive(:==).with(0).and_return(true)
    
    @obj.remainder(@other).should_equal(@result)
  end

  it.returns "the result of calling self#% with other if self and other are greater than 0" do
    @obj.should_receive(:%).with(@other).and_return(@result)
    @result.should_receive(:==).with(0).and_return(false)

    @obj.should_receive(:<).with(0).and_return(false)

    @obj.should_receive(:>).with(0).and_return(true)
    @other.should_receive(:<).with(0).and_return(false)
    
    @obj.remainder(@other).should_equal(@result)
  end

  it.returns "the result of calling self#% with other if self and other are less than 0" do
    @obj.should_receive(:%).with(@other).and_return(@result)
    @result.should_receive(:==).with(0).and_return(false)

    @obj.should_receive(:<).with(0).and_return(true)
    @other.should_receive(:>).with(0).and_return(false)

    @obj.should_receive(:>).with(0).and_return(false)
    
    @obj.remainder(@other).should_equal(@result)
  end

  it.returns "the result of calling self#% with other - other if self is greater than 0 and other is less than 0" do
    @obj.should_receive(:%).with(@other).and_return(@result)
    @result.should_receive(:==).with(0).and_return(false)

    @obj.should_receive(:<).with(0).and_return(false)
    
    @obj.should_receive(:>).with(0).and_return(true)
    @other.should_receive(:<).with(0).and_return(true)
    
    @result.should_receive(:-).with(@other).and_return(:result)
    
    @obj.remainder(@other).should_equal(:result)
  end

  it.returns "the result of calling self#% with other - other if self is less than 0 and other is greater than 0" do
    @obj.should_receive(:%).with(@other).and_return(@result)
    @result.should_receive(:==).with(0).and_return(false)

    @obj.should_receive(:<).with(0).and_return(true)
    @other.should_receive(:>).with(0).and_return(true)
    
    @result.should_receive(:-).with(@other).and_return(:result)
    
    @obj.remainder(@other).should_equal(:result)
  end
end
