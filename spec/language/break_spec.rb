# require File.dirname(__FILE__) + '/../spec_helper'

describe "The break statement" do |it| 
  it.raises " a LocalJumpError if used not within block or while/for loop" do
    def x; break; end
    lambda { x }.should_raise(LocalJumpError)
  end

  it.can "ends block execution if used whithin block" do
    a = []
    lambda {
      a << 1
      break
      a << 2
    }.call
    a.should_equal([1])
  end

  it.can "causes block to return value passed to break" do
    lambda { break 123; 456 }.call.should_equal(123)
  end

  it.can "causes block to return nil if an empty expression passed to break" do
    lambda { break (); 456 }.call.should_be_nil
  end

  it.can "causes block to return nil if no value passed to break" do
    lambda { break; 456 }.call.should_equal(nil)
  end
end

describe "Executing break from within a block" do |it| 
  it.returns "from the invoking singleton method" do
    obj = Object.new
    def obj.meth_with_block
      yield
      fail("break didn't break from the singleton method")
    end
    obj.meth_with_block { break :value }.should_equal(:value)
  end

  it.returns "from the invoking method with the argument to break" do
    class BreakTest
      def self.meth_with_block
        yield
        fail("break didn't break from the method")
      end
    end
    BreakTest.meth_with_block { break :value }.should_equal(:value)
  end

  # Discovered in JRuby (see JRUBY-2756)
  it.returns "from the original invoking method even in case of chained calls" do
    class BreakTest
      # case #1: yield
      def self.meth_with_yield(&b)
        yield
        fail("break returned from yield to wrong place")
      end
      def self.invoking_method(&b)
        meth_with_yield(&b)
        fail("break returned from 'meth_with_yield' method to wrong place")
      end

      # case #2: block.call
      def self.meth_with_block_call(&b)
        b.call
        fail("break returned from b.call to wrong place")
      end
      def self.invoking_method2(&b)
        meth_with_block_call(&b)
        fail("break returned from 'meth_with_block_call' method to wrong place")
      end
    end

    # this calls a method that calls another method that yields to the block
    BreakTest.invoking_method do
      break
      fail("break didn't, well, break")
    end

    # this calls a method that calls another method that calls the block
    BreakTest.invoking_method2 do
      break
      fail("break didn't, well, break")
    end

    res = BreakTest.invoking_method do
      break :return_value
      fail("break didn't, well, break")
    end
    res.should_equal(:return_value)

    res = BreakTest.invoking_method2 do
      break :return_value
      fail("break didn't, well, break")
    end
    res.should_equal(:return_value)

  end
end

describe "Breaking out of a loop with a value" do |it| 

  it.can "assigns objects" do
    a = loop do break; end;          a.should_equal(nil)
    a = loop do break nil; end;      a.should_equal(nil)
    a = loop do break 1; end;        a.should_equal(1)
    a = loop do break []; end;       a.should_equal([])
    a = loop do break [1]; end;      a.should_equal([1])
    a = loop do break [nil]; end;    a.should_equal([nil])
    a = loop do break [[]]; end;     a.should_equal([[]])
    a = loop do break [*[]]; end;    a.should_equal([])
    a = loop do break [*[1]]; end;   a.should_equal([1])
    a = loop do break [*[1,2]]; end; a.should_equal([1,2])
  end

  it.can "assigns splatted objects" do
    a = loop do break *nil; end;      a.should_equal(nil)
    a = loop do break *1; end;        a.should_equal(1)
    a = loop do break *[]; end;       a.should_equal(nil)
    a = loop do break *[1]; end;      a.should_equal(1)
    a = loop do break *[nil]; end;    a.should_equal(nil)
    a = loop do break *[[]]; end;     a.should_equal([])
    a = loop do break *[*[]]; end;    a.should_equal(nil)
    a = loop do break *[1]; end;      a.should_equal(1)
    a = loop do break *[*[1]]; end;   a.should_equal(1)
    a = loop do break *[1,2]; end;    a.should_equal([1,2])
    a = loop do break *[*[1,2]]; end; a.should_equal([1,2])
  end

  it.can "assigns to a splatted reference" do
    *a = loop do break; end;          a.should_equal([nil])
    *a = loop do break nil; end;      a.should_equal([nil])
    *a = loop do break 1; end;        a.should_equal([1])
    *a = loop do break []; end;       a.should_equal([[]])
    *a = loop do break [1]; end;      a.should_equal([[1]])
    *a = loop do break [nil]; end;    a.should_equal([[nil]])
    *a = loop do break [[]]; end;     a.should_equal([[[]]])
    *a = loop do break [1,2]; end;    a.should_equal([[1,2]])
    *a = loop do break [*[]]; end;    a.should_equal([[]])
    *a = loop do break [*[1]]; end;   a.should_equal([[1]])
    *a = loop do break [*[1,2]]; end; a.should_equal([[1,2]])
  end

  it.can "assigns splatted objects to a splatted reference" do
    *a = loop do break *nil; end;      a.should_equal([nil])
    *a = loop do break *1; end;        a.should_equal([1])
    *a = loop do break *[]; end;       a.should_equal([nil])
    *a = loop do break *[1]; end;      a.should_equal([1])
    *a = loop do break *[nil]; end;    a.should_equal([nil])
    *a = loop do break *[[]]; end;     a.should_equal([[]])
    *a = loop do break *[1,2]; end;    a.should_equal([[1,2]])
    *a = loop do break *[*[]]; end;    a.should_equal([nil])
    *a = loop do break *[*[1]]; end;   a.should_equal([1])
    *a = loop do break *[*[1,2]]; end; a.should_equal([[1,2]])
  end

  it.can "assigns splatted objects to a splatted reference from a splatted loop" do
    *a = *loop do break *nil; end;      a.should_equal([nil])
    *a = *loop do break *1; end;        a.should_equal([1])
    *a = *loop do break *[]; end;       a.should_equal([nil])
    *a = *loop do break *[1]; end;      a.should_equal([1])
    *a = *loop do break *[nil]; end;    a.should_equal([nil])
    *a = *loop do break *[[]]; end;     a.should_equal([])
    *a = *loop do break *[1,2]; end;    a.should_equal([1,2])
    *a = *loop do break *[*[]]; end;    a.should_equal([nil])
    *a = *loop do break *[*[1]]; end;   a.should_equal([1])
    *a = *loop do break *[*[1,2]]; end; a.should_equal([1,2])
  end

  it.can "assigns objects to multiple block variables" do
    a,b,*c = loop do break; end;          [a,b,c].should_equal([nil,nil,[]])
    a,b,*c = loop do break nil; end;      [a,b,c].should_equal([nil,nil,[]])
    a,b,*c = loop do break 1; end;        [a,b,c].should_equal([1,nil,[]])
    a,b,*c = loop do break []; end;       [a,b,c].should_equal([nil,nil,[]])
    a,b,*c = loop do break [1]; end;      [a,b,c].should_equal([1,nil,[]])
    a,b,*c = loop do break [nil]; end;    [a,b,c].should_equal([nil,nil,[]])
    a,b,*c = loop do break [[]]; end;     [a,b,c].should_equal([[],nil,[]])
    a,b,*c = loop do break [1,2]; end;    [a,b,c].should_equal([1,2,[]])
    a,b,*c = loop do break [*[]]; end;    [a,b,c].should_equal([nil,nil,[]])
    a,b,*c = loop do break [*[1]]; end;   [a,b,c].should_equal([1,nil,[]])
    a,b,*c = loop do break [*[1,2]]; end; [a,b,c].should_equal([1,2,[]])
  end

  it.can "assigns splatted objects to multiple block variables" do
    a,b,*c = loop do break *nil; end;      [a,b,c].should_equal([nil,nil,[]])
    a,b,*c = loop do break *1; end;        [a,b,c].should_equal([1,nil,[]])
    a,b,*c = loop do break *[]; end;       [a,b,c].should_equal([nil,nil,[]])
    a,b,*c = loop do break *[1]; end;      [a,b,c].should_equal([1,nil,[]])
    a,b,*c = loop do break *[nil]; end;    [a,b,c].should_equal([nil,nil,[]])
    a,b,*c = loop do break *[[]]; end;     [a,b,c].should_equal([nil,nil,[]])
    a,b,*c = loop do break *[1,2]; end;    [a,b,c].should_equal([1,2,[]])
    a,b,*c = loop do break *[*[]]; end;    [a,b,c].should_equal([nil,nil,[]])
    a,b,*c = loop do break *[*[1]]; end;   [a,b,c].should_equal([1,nil,[]])
    a,b,*c = loop do break *[*[1,2]]; end; [a,b,c].should_equal([1,2,[]])
  end

  it.can "stops any loop type at the correct spot" do
    i = 0; loop do break i if i == 2; i+=1; end.should_equal(2)
    i = 0; loop do break if i == 3; i+=1; end; i.should_equal(3)
    i = 0; 0.upto(5) {|i| break i if i == 2 }.should_equal(2)
    i = 0; 0.upto(5) {|i| break if i == 3 }; i.should_equal(3)
    i = 0; while (i < 5) do break i if i == 2 ; i+=1; end.should_equal(2)
    i = 0; while (i < 5) do break if i == 3 ; i+=1; end; i.should_equal(3)
  end

  it.can "stops a yielded method at the correct spot" do
    def break_test()
      yield 1
      yield 2
      yield 3
    end
    break_test {|i| break i if i == 2 }.should_equal(2)
    i = 0
    break_test {|i| break i if i == 1 }
    i.should_equal(1)
  end

end
