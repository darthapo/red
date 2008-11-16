# require File.dirname(__FILE__) + '/../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/private'

describe "The private keyword" do |it| 
  it.can "marks following methods as being private" do
    a = Private::A.new
    a.methods.should_not include("bar")
    lambda { a.bar }.should_raise(NoMethodError)

    b = Private::B.new
    b.methods.should_not include("bar")
    lambda { b.bar }.should_raise(NoMethodError)
  end

  it.is "overridden when a new class is opened" do
    c = Private::B::C.new
    c.methods.should_include("baz")
    c.baz
    Private::B::public_class_method1.should_equal(1)
    Private::B::public_class_method2.should_equal(2)
    lambda { Private::B::private_class_method1 }.should_raise(NoMethodError)
  end

  it.is "no longer in effect when the class is closed" do
    b = Private::B.new
    b.methods.should_include("foo")
    b.foo
  end

  it.can "changes visibility of previously called method" do
    f = Private::F.new
    f.foo
    module Private
      class F
        private :foo
      end
    end
    lambda { f.foo }.should_raise(NoMethodError)
  end

  it.can "changes visiblity of previously called methods with same send/call site" do
    g = Private::G.new
    lambda {
      2.times do
        g.foo
        module Private
          class G
            private :foo
          end
        end
      end
    }.should_raise(NoMethodError)
  end
end
