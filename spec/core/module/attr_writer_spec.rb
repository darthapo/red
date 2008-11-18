# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Module#attr_writer" do |it| 
  it.creates "a setter for each given attribute name" do
    c = Class.new do
      attr_writer :test1, "test2"
    end
    o = c.new

    o.respond_to?("test1").should_equal(false)
    o.respond_to?("test2").should_equal(false)

    o.respond_to?("test1=").should_equal(true)
    o.test1 = "test_1"
    o.instance_variable_get(:@test1).should_equal("test_1")

    o.respond_to?("test2=").should_equal(true)
    o.test2 = "test_2"
    o.instance_variable_get(:@test2).should_equal("test_2")
    o.send(:test1=,"test_1 updated")
    o.instance_variable_get(:@test1).should_equal("test_1 updated")
    o.send(:test2=,"test_2 updated")
    o.instance_variable_get(:@test2).should_equal("test_2 updated")
  end

  it.can "convert non string/symbol/fixnum names to strings using to_str" do
    (o = mock('test')).should_receive(:to_str).any_number_of_times.and_return("test")
    c = Class.new do
      attr_writer o
    end

    c.new.respond_to?("test").should_equal(false)
    c.new.respond_to?("test=").should_equal(true)
  end

  it.raises " a TypeError when the given names can't be converted to strings using to_str" do
    o = mock('test1')
    lambda { Class.new { attr_writer o } }.should_raise(TypeError)
    (o = mock('123')).should_receive(:to_str).and_return(123)
    lambda { Class.new { attr_writer o } }.should_raise(TypeError)
  end
end
