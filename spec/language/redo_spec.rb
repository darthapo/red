# require File.dirname(__FILE__) + '/../spec_helper'

describe "The redo statement" do |it| 
  it.raises " a LocalJumpError if used not within block or while/for loop" do
    def bad_meth_redo; redo; end
    lambda { bad_meth_redo() }.should_raise(LocalJumpError)
  end

  it.can "restarts block execution if used within block" do
    a = []
    lambda {
      a << 1
      redo if a.size < 2
      a << 2
    }.call
    a.should_equal([1, 1, 2])
  end

  it.can "re-executes the closest loop" do
    exist = [2,3]
    processed = []
    order = []
    [1,2,3,4].each do |x|
      order << x
      begin
        processed << x
        if(exist.include?(x))
          raise StandardError, "included"
        end
      rescue StandardError => e
        exist.delete(x)
        redo
      end
    end
    processed.should_equal([1,2,2,3,3,4])
    exist.should_equal([])
    order.should_equal([1,2,2,3,3,4])
  end

  it.can "re-executes the last step in enumeration" do
    list = []
    [1,2,3].each do |x|
      list << x
      break if list.size == 6
      redo if x == 3
    end
    list.should_equal([1,2,3,3,3,3])
  end  
end
