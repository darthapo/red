# require File.dirname(__FILE__) + '/../spec_helper'

describe "The catch keyword" do   |it| 
  it.can "only allows symbols and strings" do
    lambda { catch(:foo) {} }.should_not raise_error
    lambda { catch("foo") {} }.should_not raise_error
    lambda { catch 1 }.should_raise(ArgumentError)    
    lambda { catch Object.new }.should_raise(TypeError)    
  end

  it.returns "the last value of the block if it nothing is thrown" do
    catch(:exit) do      
      :noexit
    end.should_equal(:noexit)
  end
  
  it.can "matches strings as symbols" do
    lambda { catch("exit") { throw :exit } }.should_not raise_error
    lambda { catch("exit") { throw "exit" } }.should_not raise_error
  end

  it.requires " a block" do
    lambda { catch :foo }.should_raise(LocalJumpError)
  end

  it.supports "nesting" do
    i = []
    catch(:exita) do
      i << :a
      catch(:exitb) do
        i << :b
        throw :exita
        i << :after_throw
      end
      i << :b_exit
    end
    i << :a_exit

    i.should_equal([:a,:b,:a_exit])
  end

  it.supports "nesting with the same name" do
    i = []
    catch(:exit) do
      i << :a
      catch(:exit) do
        i << :b
        throw :exit,:msg
      end.should_equal(:msg)
      i << :b_exit
    end.should_equal([:a,:b,:b_exit])
    i << :a_exit

    i.should_equal([:a,:b,:b_exit,:a_exit])
  end  
end
