# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/methods'

describe "Time#_load" do |it| 
  it.will "load a time object in the old UNIX timestamp based format" do
    t = Time.local(2000, 1, 15, 20, 1, 1, 203)
    timestamp = t.to_i

    high = timestamp & ((1 << 31) - 1)

    low =  t.usec

    Time._load([high, low].pack("LL")).should_equal(t)
  end
end
