# require File.dirname(__FILE__) + '/../spec_helper'

describe "The throw keyword" do |it| 
  it.can "abandons processing" do
    i = 0
    catch(:done) do
      loop do
        i += 1
        throw :done if i > 4
      end
      i += 1
    end    
    i.should_equal(5)
  end
  
  it.supports "a second parameter" do
    msg = catch(:exit) do
      throw :exit,:msg
    end
    msg.should_equal(:msg)
  end

  it.can "uses nil as a default second parameter" do
    msg = catch(:exit) do
      throw :exit
    end
    msg.should_equal(nil)
  end

  it.can "only allows symbols and strings as it's argument" do
    lambda { throw 1 }.should_raise(ArgumentError)    
    lambda { throw Object.new }.should_raise(TypeError)    
  end

  it.can "convert strings to a symbol" do
    lambda { catch(:exit) { throw "exit" } }.should_not raise_error
    a = "exit"
    lambda { catch(:exit) { throw a } }.should_not raise_error
  end
    
  it.can "unwinds stack from within a method" do
    def throw_method(handler,val)
      throw handler,val
    end

    catch(:exit) do
      throw_method(:exit,5)
    end.should_equal(5)
  end

  it.can "unwinds stack from within a lambda" do
    c = lambda { throw :foo, :msg }
    catch(:foo) { c.call }.should_equal(:msg)
  end
  
  it.raises " a name error if outside of scope of a matching catch" do    
    lambda { throw :test,5 }.should_raise(NameError)
    lambda { catch(:different) { throw :test,5 } }.should_raise(NameError)
  end

  it.raises " a ThreadError if used to exit a thread" do
    lambda {
      catch(:what) do
        Thread.new do
          throw :what
        end.join
      end
    }.should_raise(ThreadError)
  end    
end
