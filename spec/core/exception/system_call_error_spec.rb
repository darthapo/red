# require File.dirname(__FILE__) + '/../../spec_helper'

describe "SystemCallError.new" do   |it| 
  it.requires " at least one argumentt" do
    lambda { SystemCallError.new }.should_raise(ArgumentError)
  end

  it.can "take an optional errno argument" do
    SystemCallError.should_be_ancestor_of(SystemCallError.new("message",1).class)
  end

  it.will "accept single Fixnum argument as errno" do
    SystemCallError.new(-2**24).errno.should_equal(-2**24)
    SystemCallError.new(42).errno.should_equal(42)
    SystemCallError.new(2**24).errno.should_equal(2**24)
  end
end

describe "SystemCallError#errno" do |it| 
  it.returns "nil when no errno given" do
    SystemCallError.new("message").errno.should_equal(nil)
  end  
  
  it.returns "the errno given as optional argument to new" do
    SystemCallError.new("message", -2**30).errno.should_equal(-2**30)
    SystemCallError.new("message", -1).errno.should_equal(-1)
    SystemCallError.new("message", 0).errno.should_equal(0)
    SystemCallError.new("message", 1).errno.should_equal(1)
    SystemCallError.new("message", 42).errno.should_equal(42)
    SystemCallError.new("message", 2**30).errno.should_equal(2**30)
  end
end

describe "SystemCallError#message" do |it| 
  it.should "return default message when no message given" do
    SystemCallError.new(2**28).message.should =~ /Unknown error/i
  end

  it.returns "the message given as an argument to new" do
    SystemCallError.new("message", 1).message.should  =~ /message/
    SystemCallError.new("XXX").message.should =~ /XXX/
  end
end


