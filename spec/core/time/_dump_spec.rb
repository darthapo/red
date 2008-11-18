# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/methods'

describe "Time#_dump" do |it| 
  before :each do
    @t = Time.at(946812800)
    @s = @t._dump
    @t = @t.gmtime
  end

  it.will "dump an array with a time as second element" do
    low =  @t.min  << 26 |
           @t.sec  << 20 |
           @t.usec
    low.should_equal(@s.unpack("LL").last)
  end
end

