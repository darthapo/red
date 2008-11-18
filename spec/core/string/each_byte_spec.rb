# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#each_byte" do |it| 
  it.will "passe each byte in self to the given block" do
    a = []
    "hello\x00".each_byte { |c| a << c }
    a.should_equal([104, 101, 108, 108, 111, 0])
  end

  it.will "keep iterating from the old position (to new string end) when self changes" do
    r = ""
    s = "hello world"
    s.each_byte do |c|
      r << c
      s.insert(0, "<>") if r.size < 3
    end
    r.should_equal("h><>hello world")

    r = ""
    s = "hello world"
    s.each_byte { |c| s.slice!(-1); r << c }
    r.should_equal("hello ")

    r = ""
    s = "hello world"
    s.each_byte { |c| s.slice!(0); r << c }
    r.should_equal("hlowrd")

    r = ""
    s = "hello world"
    s.each_byte { |c| s.slice!(0..-1); r << c }
    r.should_equal("h")
  end
  
  it.returns "self" do
    s = "hello"
    (s.each_byte {}).should_equal(s)
  end
end
