# require File.dirname(__FILE__) + '/../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/yield'

describe "Assignment via yield" do |it| 
  
  it.can "assigns objects to block variables" do
    def f; yield nil; end;      f {|a| a.should_equal(nil })
    def f; yield 1; end;        f {|a| a.should_equal(1 })
    def f; yield []; end;       f {|a| a.should_equal([] })
    def f; yield [1]; end;      f {|a| a.should_equal([1] })
    def f; yield [nil]; end;    f {|a| a.should_equal([nil] })
    def f; yield [[]]; end;     f {|a| a.should_equal([[]] })
    def f; yield [*[]]; end;    f {|a| a.should_equal([] })
    def f; yield [*[1]]; end;   f {|a| a.should_equal([1] })
    def f; yield [*[1,2]]; end; f {|a| a.should_equal([1,2] })
  end
  
  it.can "assigns splatted objects to block variables" do
    def f; yield *nil; end;     f {|a| a.should_equal(nil })
    def f; yield *1; end;       f {|a| a.should_equal(1 })
    def f; yield *[1]; end;     f {|a| a.should_equal(1 })
    def f; yield *[nil]; end;   f {|a| a.should_equal(nil })
    def f; yield *[[]]; end;    f {|a| a.should_equal([] })
    def f; yield *[*[1]]; end;  f {|a| a.should_equal(1 })
  end

  it.can "assigns objects followed by splatted objects to block variables" do
    def f; yield 1, *nil; end;     f {|a, b| b.should_equal(nil })
    def f; yield 1, *1; end;       f {|a, b| b.should_equal(1 })
    def f; yield 1, *[1]; end;     f {|a, b| b.should_equal(1 })
    def f; yield 1, *[nil]; end;   f {|a, b| b.should_equal(nil })
    def f; yield 1, *[[]]; end;    f {|a, b| b.should_equal([] })
    def f; yield 1, *[*[1]]; end;  f {|a, b| b.should_equal(1 })
  end

  it.can "assigns objects to block variables that include the splat operator inside the block" do
    def f; yield; end;          f {|*a| a.should_equal([] })
    def f; yield nil; end;      f {|*a| a.should_equal([nil] })
    def f; yield 1; end;        f {|*a| a.should_equal([1] })
    def f; yield []; end;       f {|*a| a.should_equal([[]] })
    def f; yield [1]; end;      f {|*a| a.should_equal([[1]] })
    def f; yield [nil]; end;    f {|*a| a.should_equal([[nil]] })
    def f; yield [[]]; end;     f {|*a| a.should_equal([[[]]] })
    def f; yield [1,2]; end;    f {|*a| a.should_equal([[1,2]] })
    def f; yield [*[]]; end;    f {|*a| a.should_equal([[]] })
    def f; yield [*[1]]; end;   f {|*a| a.should_equal([[1]] })
    def f; yield [*[1,2]]; end; f {|*a| a.should_equal([[1,2]] }    )
  end
  
  it.can "assigns objects to splatted block variables that include the splat operator inside the block" do
    def f; yield *nil; end;      f {|*a| a.should_equal([nil] })
    def f; yield *1; end;        f {|*a| a.should_equal([1] })
    def f; yield *[]; end;       f {|*a| a.should_equal([] })
    def f; yield *[1]; end;      f {|*a| a.should_equal([1] })
    def f; yield *[nil]; end;    f {|*a| a.should_equal([nil] })
    def f; yield *[[]]; end;     f {|*a| a.should_equal([[]] })
    def f; yield *[*[]]; end;    f {|*a| a.should_equal([] })
    def f; yield *[*[1]]; end;   f {|*a| a.should_equal([1] })
    def f; yield *[*[1,2]]; end; f {|*a| a.should_equal([1,2] }    )
  end
  
  it.can "assigns objects to multiple block variables" do
    def f; yield; end;          f {|a,b,*c| [a,b,c].should_equal([nil,nil,[]] })
    def f; yield nil; end;      f {|a,b,*c| [a,b,c].should_equal([nil,nil,[]] })
    def f; yield 1; end;        f {|a,b,*c| [a,b,c].should_equal([1,nil,[]] })
    def f; yield []; end;       f {|a,b,*c| [a,b,c].should_equal([nil,nil,[]] })
    def f; yield [1]; end;      f {|a,b,*c| [a,b,c].should_equal([1,nil,[]] })
    def f; yield [nil]; end;    f {|a,b,*c| [a,b,c].should_equal([nil,nil,[]] })
    def f; yield [[]]; end;     f {|a,b,*c| [a,b,c].should_equal([[],nil,[]] })
    def f; yield [*[]]; end;    f {|a,b,*c| [a,b,c].should_equal([nil,nil,[]] })
    def f; yield [*[1]]; end;   f {|a,b,*c| [a,b,c].should_equal([1,nil,[]] })
    def f; yield [*[1,2]]; end; f {|a,b,*c| [a,b,c].should_equal([1,2,[]] })
  end
  
  it.can "assigns splatted objects to multiple block variables" do
    def f; yield *nil; end;      f {|a,b,*c| [a,b,c].should_equal([nil,nil,[]] })
    def f; yield *1; end;        f {|a,b,*c| [a,b,c].should_equal([1,nil,[]] })
    def f; yield *[]; end;       f {|a,b,*c| [a,b,c].should_equal([nil,nil,[]] })
    def f; yield *[1]; end;      f {|a,b,*c| [a,b,c].should_equal([1,nil,[]] })
    def f; yield *[nil]; end;    f {|a,b,*c| [a,b,c].should_equal([nil,nil,[]] })
    def f; yield *[[]]; end;     f {|a,b,*c| [a,b,c].should_equal([[],nil,[]] })
    def f; yield *[*[]]; end;    f {|a,b,*c| [a,b,c].should_equal([nil,nil,[]] })
    def f; yield *[*[1]]; end;   f {|a,b,*c| [a,b,c].should_equal([1,nil,[]] })
    def f; yield *[*[1,2]]; end; f {|a,b,*c| [a,b,c].should_equal([1,2,[]] }    )
  end
  
end

describe "The yield keyword" do |it| 
  it.raises " a LocalJumpError when invoked in a method not passed a block" do
    lambda { YieldSpecs::no_block }.should_raise(LocalJumpError)
  end
end
