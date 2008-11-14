require "#{File.dirname __FILE__}/../../../spec_helper"
require "#{File.dirname __FILE__}/../fixtures/classes"

describe :method_to_s, :shared => true do
  before :each do
    @m = MethodSpecs::MySub.new.method :bar
  end

  it.returns "a String" do
    @m.send(@method).class.should_equal(String)
  end

  it.should "reflects that this is a Method object in its String" do
    @m.send(@method).should =~ /\bMethod\b/
  end
end
