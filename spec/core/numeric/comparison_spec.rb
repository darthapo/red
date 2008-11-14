# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Numeric#<=>" do |it| 
  before(:each) do
    @obj = NumericSub.new
  end

  it.returns "0 if self equals other" do
    (@obj <=> @obj).should_equal(0)
  end
  
  it.returns "nil if self does not equal other" do
    (@obj <=> NumericSub.new).should_equal(nil)
    (@obj <=> 10).should_equal(nil)
    (@obj <=> -3.5).should_equal(nil)
    (@obj <=> bignum_value).should_equal(nil)
  end
end