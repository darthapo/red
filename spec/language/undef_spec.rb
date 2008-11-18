# require File.dirname(__FILE__) + '/../spec_helper'

class UndefSpecClass
  def meth(other);other;end
end

describe "The undef keyword" do |it| 
  it.can "undefines 'meth='" do
    obj = UndefSpecClass.new
    (obj.meth 5).should_equal(5)
    class UndefSpecClass
      undef meth
    end
    lambda { obj.meth 5 }.should_raise(NoMethodError)
  end
end
