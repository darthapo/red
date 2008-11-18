# require File.dirname(__FILE__) + '/../spec_helper'

describe "the return keyword" do |it| 

  it.returns "any object directly" do
    def r; return 1; end;        r().should_equal(1)
  end

  it.returns "an single element array directly" do
    def r; return [1]; end;      r().should_equal([1])
  end

  it.returns "an multi element array directly" do
    def r; return [1,2]; end;    r().should_equal([1,2])
  end

  it.returns "nil by default" do
    def r; return; end;          r().should_be_nil
  end
end

describe "return in a Thread" do |it| 
  it.raises " a ThreadError if used to exit a thread" do
    lambda { Thread.new { return }.join }.should_raise(ThreadError)
  end
end

describe "return when passed a splat" do |it| 
  it.returns "nil when the ary is empty" do
    def r; ary = []; return *ary; end;    r.should_be_nil
  end

  it.returns "the first element when the array is size of 1" do
    def r; ary = [1]; return *ary; end;   r.should_equal(1)
  end

  it.returns "the whole array when size is greater than 1" do
    def r; ary = [1,2]; return *ary; end; r.should_equal([1,2])
    def r; ary = [1,2,3]; return *ary; end; r.should_equal([1,2,3])
  end

  it.returns "a non-array when used as a splat" do
    def r; value = 1; return *value; end;  r.should_equal(1)
  end

  it.calls " 'to_a' on the splatted value first" do
    def r
      obj = Object.new
      def obj.to_a
        []
      end

      return *obj
    end

    r().should_be_nil

    def r
      obj = Object.new
      def obj.to_a
        [1]
      end

      return *obj
    end

    r().should_equal(1)

    def r
      obj = Object.new
      def obj.to_a
        [1,2]
      end

      return *obj
    end

    r().should_equal([1,2])
  end

  it.calls " 'to_ary' on the splatted value first" do
    def r
      obj = Object.new
      def obj.to_ary
        []
      end

      return *obj
    end

    r().should_be_nil

    def r
      obj = Object.new
      def obj.to_ary
        [1]
      end

      return *obj
    end

    r().should_equal(1)

    def r
      obj = Object.new
      def obj.to_ary
        [1,2]
      end

      return *obj
    end

    r().should_equal([1,2])
  end
end

describe "return from within a begin" do |it| 
  it.can "executes ensure before returning from function" do
    def f(a)
      begin
        return a
      ensure
        a << 1
      end
    end
    f([]).should_equal([1])
  end

  it.can "executes return in ensure before returning from function" do
    def f(a)
      begin
        return a
      ensure
        return [0]
        a << 1
      end
    end
    f([]).should_equal([0])
  end

  it.can "executes ensures in stack order before returning from function" do
    def f(a)
      begin
        begin
          return a
        ensure
          a << 2
        end
      ensure
        a << 1
      end
    end
    f([]).should_equal([2,1])
  end

  it.can "executes return at base of ensure stack" do
    def f(a)
      begin
        begin
          return a
        ensure
          a << 2
          return 2
        end
      ensure
        a << 1
        return 1
      end
    end
    a = []
    f(a).should_equal(1)
    a.should_equal([2, 1])
  end
end

describe "Return from within a block" do |it| 
  it.raises " a LocalJumpError if there is no lexicaly enclosing method" do
    def f; yield; end
    lambda { f { return 5 } }.should_raise(LocalJumpError)
  end

  it.can "causes lambda to return nil if invoked without any arguments" do
    lambda { return; 456 }.call.should_be_nil
  end

  it.can "causes lambda to return nil if invoked with an empty expression" do
    lambda { return (); 456 }.call.should_be_nil
  end

  it.can "causes lambda to return the value passed to return" do
    lambda { return 123; 456 }.call.should_equal(123)
  end

  it.can "causes the method that lexically encloses the block to return" do
    def meth_with_yield
      yield
      fail("return returned to wrong location")
    end

    def enclosing_method
      meth_with_yield do
        return :return_value
        fail("return didn't, well, return")
      end
      fail("return should not behave like break")
    end

    enclosing_method.should_equal(:return_value)
  end

  it.returns "from the lexically enclosing method even in case of chained calls" do
    class ChainedReturnTest
      def self.meth_with_yield(&b)
        yield
        fail("returned from yield to wrong place")
      end
      def self.invoking_method(&b)
        meth_with_yield(&b)
        fail("returned from 'meth_with_yield' method to wrong place")
      end
      def self.enclosing_method
        invoking_method do
          return :return_value
          fail("return didn't, well, return")
        end
        fail("return should not behave like break")
      end
    end

    ChainedReturnTest.enclosing_method.should_equal(:return_value)
  end

end

