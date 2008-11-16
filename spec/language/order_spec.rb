# require File.dirname(__FILE__) + '/../spec_helper'

describe "A method call" do |it| 
  before :each do
    @obj = Object.new
    def @obj.foo(a, b, &c)
      [a, b, c ? c.call : nil]
    end
  end

  it.can "evaluates the receiver first" do
    (obj = @obj).foo(obj = nil, obj = nil).should_equal([nil, nil, nil])
  end

  it.can "evaluates arguments after receiver" do
    a = 0
    (a += 1; @obj).foo(a, a).should_equal([1, 1, nil])
    a.should_equal(1)
  end

  it.can "evaluates arguments left-to-right" do
    a = 0
    @obj.foo(a += 1, a += 1).should_equal([1, 2, nil])
    a.should_equal(2)
  end

  it.can "evaluates block pass before arguments" do
    a = 0
    p = proc {true}
    @obj.foo(a += 1, a += 1, &(a += 1; p)).should_equal([2, 3, true])
    a.should_equal(3)
  end

  it.can "evaluates block pass before receiver" do
    p1 = proc {true}
    p2 = proc {false}
    p1.should_not == p2

    p = p1
    (p = p2; @obj).foo(1, 1, &p).should_equal([1, 1, true])
  end
end
