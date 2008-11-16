# require File.dirname(__FILE__) + '/../spec_helper'

# Language-level method behaviour
describe "Redefining a method" do |it| 
  it.will "replace the original method" do
    def barfoo; 100; end
    barfoo.should_equal(100)

    def barfoo; 200; end
    barfoo.should_equal(200)
  end
end

describe "Defining an 'initialize' method" do |it| 
  it.should "make it private" do
    class DefInitializeSpec
      def initialize
      end
    end
    DefInitializeSpec.new.private_methods(false).should_include('initialize')
  end
end

describe "Defining an 'initialize_copy' method" do |it| 
  it.should "make it private" do
    class DefInitializeCopySpec
      def initialize_copy
      end
    end
    DefInitializeCopySpec.new.private_methods(false).should_include('initialize_copy')
  end
end

describe "An instance method definition with a splat" do |it| 
  it.will "accept an unnamed '*' argument" do
    def foo(*); end;

    foo.should_equal(nil)
    foo(1, 2).should_equal(nil)
    foo(1, 2, 3, 4, :a, :b, 'c', 'd').should_equal(nil)
  end

  it.will "accept a named * argument" do
    def foo(*a); a; end;
    foo.should_equal([])
    foo(1, 2).should_equal([1, 2])
    foo([:a]).should_equal([[:a]])
  end

  it.will "accept non-* arguments before the * argument" do
    def foo(a, b, c, d, e, *f); [a, b, c, d, e, f]; end
    foo(1, 2, 3, 4, 5, 6, 7, 8).should_equal([1, 2, 3, 4, 5, [6, 7, 8]])
  end

  it.creates "a method that can be invoked with an inline hash argument" do
    def foo(a,b,*c); [a,b,c] end

    foo('abc', 'rbx' => 'cool', 'specs' => 'fail sometimes', 'oh' => 'shit', *[789, 'yeah']).
      should ==
      ['abc', { 'rbx' => 'cool', 'specs' => 'fail sometimes', 'oh' => 'shit'}, [789, 'yeah']]
  end

  it.creates "a method that can be invoked with an inline hash and a block" do
    def foo(a,b,*c,&d); [a,b,c,yield(d)] end

    foo('abc', 'rbx' => 'cool', 'specs' => 'fail sometimes', 'oh' => 'shit', *[789, 'yeah']) { 3 }.
      should ==
      ['abc', { 'rbx' => 'cool', 'specs' => 'fail sometimes', 'oh' => 'shit'}, [789, 'yeah'], 3]

    foo('abc', 'rbx' => 'cool', 'specs' => 'fail sometimes', *[789, 'yeah']) do 3 end.should ==
      ['abc', { 'rbx' => 'cool', 'specs' => 'fail sometimes' }, [789, 'yeah'], 3]

    l = lambda { 3 }

    foo('abc', 'rbx' => 'cool', 'specs' => 'fail sometimes', *[789, 'yeah'], &l).should ==
      ['abc', { 'rbx' => 'cool', 'specs' => 'fail sometimes' }, [789, 'yeah'], 3]
  end

  it.can "allows only a single * argument" do
    lambda { eval 'def foo(a, *b, *c); end' }.should_raise(SyntaxError)
  end

  it.requires " the presence of any arguments that precede the *" do
    def foo(a, b, *c); end
    lambda { foo 1 }.should_raise(ArgumentError)
  end
end

describe "An instance method with a default argument" do |it| 
  it.can "evaluates the default when no arguments are passed" do
    def foo(a = 1)
      a
    end
    foo.should_equal(1)
    foo(2).should_equal(2)
  end

  it.can "evaluates the default empty expression when no arguments are passed" do
    def foo(a = ())
      a
    end
    foo.should_equal(nil)
    foo(2).should_equal(2)
  end

  it.can "assigns an empty Array to an unused splat argument" do
    def foo(a = 1, *b)
      [a,b]
    end
    foo.should_equal([1, []])
    foo(2).should_equal([2, []])
  end

  it.can "evaluates the default when required arguments precede it" do
    def foo(a, b = 2)
      [a,b]
    end
    lambda { foo }.should_raise(ArgumentError)
    foo(1).should_equal([1, 2])
  end

  it.can "prefers to assign to a default argument before a splat argument" do
    def foo(a, b = 2, *c)
      [a,b,c]
    end
    lambda { foo }.should_raise(ArgumentError)
    foo(1).should_equal([1,2,[]])
  end

  it.can "prefers to assign to a default argument when there are no required arguments" do
    def foo(a = 1, *args)
      [a,args]
    end
    foo(2,2).should_equal([2,[2]])
  end

  it.does_not "evaluate the default when passed a value and a * argument" do
    def foo(a, b = 2, *args)
      [a,b,args]
    end
    foo(2,3,3).should_equal([2,3,[3]])
  end
end

describe "A singleton method definition" do |it| 
  it.can "can be declared for a local variable" do
    a = "hi"
    def a.foo
      5
    end
    a.foo.should_equal(5)
  end

  it.can "can be declared for an instance variable" do
    @a = "hi"
    def @a.foo
      6
    end
    @a.foo.should_equal(6)
  end

  it.can "can be declared for a global variable" do
    $__a__ = "hi"
    def $__a__.foo
      7
    end
    $__a__.foo.should_equal(7)
  end

  it.can "can be declared for a class variable" do
    @@a = "hi"
    def @@a.foo
      8
    end
    @@a.foo.should_equal(8)
  end

  it.can "can be declared with an empty method body" do
    class DefSpec
      def self.foo;end
    end
    DefSpec.foo.should_equal(nil)
  end
end

describe "Redefining a singleton method" do |it| 
  it.does_not "inherit a previously set visibility " do
    o = Object.new

    class << o; private; def foo; end; end;

    class << o; private_instance_methods.include?("foo").should_equal(true; end)

    class << o; def foo; end; end;

    class << o; private_instance_methods.include?("foo").should_equal(false; end)
    class << o; instance_methods.include?("foo").should_equal(true ; end)

  end
end

describe "Redefining a singleton method" do |it| 
  it.does_not "inherit a previously set visibility " do
    o = Object.new

    class << o; private; def foo; end; end;

    class << o; private_instance_methods.include?("foo").should_equal(true; end)

    class << o; def foo; end; end;

    class << o; private_instance_methods.include?("foo").should_equal(false; end)
    class << o; instance_methods.include?("foo").should_equal(true ; end)

  end
end

describe "A method defined with extreme default arguments" do |it| 
  it.can "can redefine itself when the default is evaluated" do
    class DefSpecs
      def foo(x = (def foo; "hello"; end;1));x;end
    end

    d = DefSpecs.new
    d.foo(42).should_equal(42)
    d.foo.should_equal(1)
    d.foo.should_equal('hello')
  end

  it.can "may use an fcall as a default" do
    def foo(x = caller())
      x
    end
    foo.shift.class.should_equal(String)
  end

  it.can "evaluates the defaults in the method's scope" do
    def foo(x = ($foo_self = self; nil)); end
    foo
    $foo_self.should_equal(self)
  end

  it.can "may use preceding arguments as defaults" do
    def foo(obj, width=obj.length)
      width
    end
    foo('abcde').should_equal(5)
  end

  it.can "may use a lambda as a default" do
    def foo(output = 'a', prc = lambda {|n| output * n})
      prc.call(5)
    end
    foo.should_equal('aaaaa' )
  end
end

describe "A singleton method defined with extreme default arguments" do |it| 
  it.can "may use a method definition as a default" do
    $__a = "hi"
    def $__a.foo(x = (def $__a.foo; "hello"; end;1));x;end

    $__a.foo(42).should_equal(42)
    $__a.foo.should_equal(1)
    $__a.foo.should_equal('hello')
  end

  it.can "may use an fcall as a default" do
    a = "hi"
    def a.foo(x = caller())
      x
    end
    a.foo.shift.class.should_equal(String)
  end

  it.can "evaluates the defaults in the singleton scope" do
    a = "hi"
    def a.foo(x = ($foo_self = self; nil)); 5 ;end
    a.foo
    $foo_self.should_equal(a)
  end

  it.can "may use preceding arguments as defaults" do
    a = 'hi'
    def a.foo(obj, width=obj.length)
      width
    end
    a.foo('abcde').should_equal(5)
  end
  
  it.can "may use a lambda as a default" do
    a = 'hi'
    def a.foo(output = 'a', prc = lambda {|n| output * n})
      prc.call(5)
    end
    a.foo.should_equal('aaaaa' )
  end
end

describe "A method definition inside a metaclass scope" do |it| 
  it.can "can create a class method" do
    class DefSpecSingleton
      class << self
        def a_class_method;self;end
      end
    end

    DefSpecSingleton.a_class_method.should_equal(DefSpecSingleton)
    lambda { Object.a_class_method }.should_raise(NoMethodError)
  end

  it.can "can create a singleton method" do
    obj = Object.new
    class << obj
      def a_singleton_method;self;end
    end

    obj.a_singleton_method.should_equal(obj)
    lambda { Object.new.a_singleton_method }.should_raise(NoMethodError)
  end
end

describe "A nested method definition" do |it| 
  it.creates "an instance method when evaluated in an instance method" do
    class DefSpecNested
      def create_instance_method
        def an_instance_method;self;end
        an_instance_method
      end
    end

    obj = DefSpecNested.new
    obj.create_instance_method.should_equal(obj)
    obj.an_instance_method.should_equal(obj)

    other = DefSpecNested.new
    other.an_instance_method.should_equal(other)

    DefSpecNested.instance_methods.should_include("an_instance_method")
  end

  it.creates "a class method when evaluated in a class method" do
    class DefSpecNested
      class << self
        def create_class_method
          def a_class_method;self;end
          a_class_method
        end
      end
    end

    lambda { DefSpecNested.a_class_method }.should_raise(NoMethodError)
    DefSpecNested.create_class_method.should_equal(DefSpecNested)
    DefSpecNested.a_class_method.should_equal(DefSpecNested)
    lambda { Object.a_class_method }.should_raise(NoMethodError)
    lambda { DefSpecNested.new.a_class_method }.should_raise(NoMethodError)
  end

  it.creates "a singleton method when evaluated in the metaclass of an instance" do
    class DefSpecNested
      def create_singleton_method
        class << self
          def a_singleton_method;self;end
        end
        a_singleton_method
      end
    end

    obj = DefSpecNested.new
    obj.create_singleton_method.should_equal(obj)
    obj.a_singleton_method.should_equal(obj)

    other = DefSpecNested.new
    lambda { other.a_singleton_method }.should_raise(NoMethodError)
  end
end

describe "A method definition inside an instance_eval" do |it| 
  it.creates "a singleton method" do
    obj = Object.new
    obj.instance_eval do
      def an_instance_eval_method;self;end
    end
    obj.an_instance_eval_method.should_equal(obj)

    other = Object.new
    lambda { other.an_instance_eval_method }.should_raise(NoMethodError)
  end

  it.creates "a singleton method when evaluated inside a metaclass" do
    obj = Object.new
    obj.instance_eval do
      class << self
        def a_metaclass_eval_method;self;end
      end
    end
    obj.a_metaclass_eval_method.should_equal(obj)

    other = Object.new
    lambda { other.a_metaclass_eval_method }.should_raise(NoMethodError)
  end

  it.creates "a class method when the receiver is a class" do
    DefSpecNested.instance_eval do
      def an_instance_eval_class_method;self;end
    end

    DefSpecNested.an_instance_eval_class_method.should_equal(DefSpecNested)
    lambda { Object.an_instance_eval_class_method }.should_raise(NoMethodError)
  end
end

describe "A method definition in an eval" do |it| 
  it.creates "an instance method" do
    class DefSpecNested
      def eval_instance_method
        eval "def an_eval_instance_method;self;end", binding
        an_eval_instance_method
      end
    end

    obj = DefSpecNested.new
    obj.eval_instance_method.should_equal(obj)
    obj.an_eval_instance_method.should_equal(obj)

    other = DefSpecNested.new
    other.an_eval_instance_method.should_equal(other)

    lambda { Object.new.an_eval_instance_method }.should_raise(NoMethodError)
  end

  it.creates "a class method" do
    class DefSpecNestedB
      class << self
        def eval_class_method
          eval "def an_eval_class_method;self;end" #, binding
          an_eval_class_method
        end
      end
    end

    DefSpecNestedB.eval_class_method.should_equal(DefSpecNestedB)
    DefSpecNestedB.an_eval_class_method.should_equal(DefSpecNestedB)

    lambda { Object.an_eval_class_method }.should_raise(NoMethodError)
    lambda { DefSpecNestedB.new.an_eval_class_method}.should_raise(NoMethodError)
  end

  it.creates "a singleton method" do
    class DefSpecNested
      def eval_singleton_method
        class << self
          eval "def an_eval_singleton_method;self;end", binding
        end
        an_eval_singleton_method
      end
    end

    obj = DefSpecNested.new
    obj.eval_singleton_method.should_equal(obj)
    obj.an_eval_singleton_method.should_equal(obj)

    other = DefSpecNested.new
    lambda { other.an_eval_singleton_method }.should_raise(NoMethodError)
  end
end

describe "a method definition that sets more than one default parameter all to the same value" do |it| 
  def foo(a=b=c={})
    [a,b,c]
  end
  it.can "assigns them all the same object by default" do
    foo.should_equal([{},{},{}])
    a, b, c = foo
    a.should_equal(b)
    a.should_equal(c)
  end

  it.can "allows the first argument to be given, and sets the rest to null" do
    foo(1).should_equal([1,nil,nil])
  end

  it.can "assigns the parameters different objects across different default calls" do
    a, b, c = foo
    d, e, f = foo
    a.should_not equal(d)
  end

  it.can "only allows overriding the default value of the first such parameter in each set" do
    lambda { foo(1,2) }.should_raise(ArgumentError)
  end

  def bar(a=b=c=1,d=2)
    [a,b,c,d]
  end

  it.can "treats the argument after the multi-parameter normally" do
    bar.should_equal([1,1,1,2])
    bar(3).should_equal([3,nil,nil,2])
    bar(3,4).should_equal([3,nil,nil,4])
    lambda { bar(3,4,5) }.should_raise(ArgumentError)
  end
end
