# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Method#unbind" do |it| 
  it.before(:each) do
    @normal = MethodSpecs::Methods.new
    @normal_m = @normal.method :foo
    @normal_um = @normal_m.unbind
    @pop_um = MethodSpecs::MySub.new.method(:bar).unbind
  end

  it.returns "an UnboundMethod" do
    @normal_um.class.should_equal(UnboundMethod)
  end
end
