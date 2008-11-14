# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Numeric#+@" do     |it| 
  it.returns "self" do
    obj = NumericSub.new
    obj.send(:+@).should_equal(obj)
  end
end
