# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Module#attr_reader" do |it| 
  it.creates "a getter for each given attribute name" do
    c = Class.new do
      attr_reader :a, "b"
      
      def initialize
        @a = "test"
        @b = "test2"
      end
    end
    
    o = c.new
    %w{a b}.each do |x|
      o.respond_to?(x).should_equal(true)
      o.respond_to?("#{x}=").should_equal(false)
    end

    o.a.should_equal("test")
    o.b.should_equal("test2")
    o.send(:a).should_equal("test")
    o.send(:b).should_equal("test2")
  end

  it.can "convert non string/symbol/fixnum names to strings using to_str" do
    (o = mock('test')).should_receive(:to_str).any_number_of_times.and_return("test")
    c = Class.new do
      attr_reader o
    end
    
    c.new.respond_to?("test").should_equal(true)
    c.new.respond_to?("test=").should_equal(false)
  end

  it.raises " a TypeError when the given names can't be converted to strings using to_str" do
    o = mock('o')
    lambda { Class.new { attr_reader o } }.should_raise(TypeError)
    (o = mock('123')).should_receive(:to_str).and_return(123)
    lambda { Class.new { attr_reader o } }.should_raise(TypeError)
  end
end
