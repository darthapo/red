# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Hash#default" do |it| 
  it.returns "the default value" do
    h = Hash.new(5)
    h.default.should_equal(5)
    h.default(4).should_equal(5)
    {}.default.should_equal(nil)
    {}.default(4).should_equal(nil)
  end

  it.can "uses the default proc to compute a default value, passing given key" do
    h = Hash.new { |*args| args }
    h.default(nil).should_equal([h, nil])
    h.default(5).should_equal([h, 5])
  end
  
  it.calls " default proc with nil arg if passed a default proc but no arg" do
    h = Hash.new { |*args| args }
    h.default.should_equal(nil)
  end
end

describe "Hash#default=" do |it| 
  it.can "set the default value" do
    h = Hash.new
    h.default = 99
    h.default.should_equal(99)
  end

  it.can "unset the default proc" do
    [99, nil, lambda { 6 }].each do |default|
      h = Hash.new { 5 }
      h.default_proc.should_not == nil
      h.default = default
      h.default.should_equal(default)
      h.default_proc.should_equal(nil)
    end
  end
end
