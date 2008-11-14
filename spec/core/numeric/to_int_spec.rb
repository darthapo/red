# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Numeric#to_int" do   |it| 
  it.returns "self#to_i" do
    obj = NumericSub.new
    obj.should_receive(:to_i).and_return(:result)
    obj.to_int.should_equal(:result)
  end
end