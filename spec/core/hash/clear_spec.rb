# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Hash#clear" do |it| 
  it.will "remove all key, value pairs" do
    h = { 1 => 2, 3 => 4 }
    h.clear.should_equal(h)
    h.should_equal({})
  end

  it.does_not "remove default values" do
    h = Hash.new(5)
    h.clear
    h.default.should_equal(5)

    h = { "a" => 100, "b" => 200 }
    h.default = "Go fish"
    h.clear
    h["z"].should_equal("Go fish")
  end

  it.does_not "remove default procs" do
    h = Hash.new { 5 }
    h.clear
    h.default_proc.should_not == nil
  end
end
