# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Module#module_function with specific method names" do |it| 
  it.creates "duplicates of the given instance methods on the Module object" do
    m = Module.new do
      def test()  end
      def test2() end
      def test3() end

      module_function :test, :test2
    end

    m.respond_to?(:test).should  == true
    m.respond_to?(:test2).should_equal(true)
    m.respond_to?(:test3).should_equal(false)
  end

  it.returns "the current module" do
    x = nil
    m = Module.new do
      def test()  end
      x = module_function :test
    end

    x.should_equal(m)
  end

  it.creates "an independent copy of the method, not a redirect" do
    module Mixin
      def test
        "hello"
      end
      module_function :test
    end

    class BaseClass
      include Mixin
      def call_test
        test
      end
    end

    Mixin.test.should_equal("hello")
    c = BaseClass.new
    c.call_test.should_equal("hello")

    module Mixin
      def test
        "goodbye"
      end
    end

    Mixin.test.should_equal("hello")
    c.call_test.should_equal("goodbye")
  end

  it.can "makes the instance methods private" do
    m = Module.new do
      def test() "hello" end
      module_function :test
    end

    (o = mock('x')).extend(m)
    o.respond_to?(:test).should_equal(false)
    m.private_instance_methods.map {|m| m.to_s }.include?('test').should_equal(true)
    o.private_methods.map {|m| m.to_s }.include?('test').should_equal(true)
    o.send(:test).should_equal("hello")
  end

  it.can "makes the new Module methods public" do
    m = Module.new do
      def test() "hello" end
      module_function :test
    end

    m.public_methods.map {|m| m.to_s }.include?('test').should_equal(true)
  end

  it.tries "to convert the given names to strings using to_str" do
    (o = mock('test')).should_receive(:to_str).any_number_of_times.and_return("test")
    (o2 = mock('test2')).should_receive(:to_str).any_number_of_times.and_return("test2")

    m = Module.new do
      def test() end
      def test2() end
      module_function o, o2
    end

    m.respond_to?(:test).should  == true
    m.respond_to?(:test2).should_equal(true)
  end

  it.raises " a TypeError when the given names can't be converted to string using to_str" do
    o = mock('123')

    lambda { Module.new { module_function(o) } }.should_raise(TypeError)

    o.should_receive(:to_str).and_return(123)
    lambda { Module.new { module_function(o) } }.should_raise(TypeError)
  end
end

describe "Module#module_function as a toggle (no arguments) in a Module body" do |it| 
  it.can "makes any subsequently defined methods module functions with the normal semantics" do
    m = Module.new {
          module_function
            def test1() end
            def test2() end
        }

    m.respond_to?(:test1).should_equal(true)
    m.respond_to?(:test2).should_equal(true)
  end

  it.returns "the current module" do
    x = nil
    m = Module.new {
      x = module_function
    }

    x.should_equal(m)
  end

  it.can "stops creating module functions if the body encounters another toggle " \
     "like public/protected/private without arguments" do
    m = Module.new {
          module_function
            def test1() end
            def test2() end
          public
            def test3() end
        }

    m.respond_to?(:test1).should_equal(true)
    m.respond_to?(:test2).should_equal(true)
    m.respond_to?(:test3).should_equal(false)
  end

  it.does_not "stop creating module functions if the body encounters " \
     "public/protected/private WITH arguments" do
    m = Module.new {
          def foo() end

          module_function
            def test1() end
            def test2() end

            public :foo

            def test3() end
        }

    m.respond_to?(:test1).should_equal(true)
    m.respond_to?(:test2).should_equal(true)
    m.respond_to?(:test3).should_equal(true)
  end

  it.does_not "affect module_evaled method definitions also if outside the eval itself" do
    m = Module.new {
          module_function

          module_eval { def test1() end }
          module_eval " def test2() end "
        }

    c = Class.new { include m }

    m.respond_to?(:test1).should_equal(false)
    m.respond_to?(:test2).should_equal(false)
  end

  it.can "has no effect if inside a module_eval if the definitions are outside of it" do
    m = Module.new {
          module_eval { module_function }

          def test1() end
          def test2() end
        }

    m.respond_to?(:test1).should_equal(false)
    m.respond_to?(:test2).should_equal(false)
  end

  it.can "functions normally if both toggle and definitions inside a module_eval" do
    m = Module.new {
          module_eval {
            module_function

            def test1() end
            def test2() end
          }
        }

    m.respond_to?(:test1).should_equal(true)
    m.respond_to?(:test2).should_equal(true)
  end

  it.can "affects evaled method definitions also even when outside the eval itself" do
    m = Module.new {
          module_function

          eval "def test1() end"
        }

    m.respond_to?(:test1).should_equal(true)
  end

  it.can "affects definitions when inside an eval even if the definitions are outside of it" do
    m = Module.new {
          eval "module_function"

          def test1() end
        }

    m.respond_to?(:test1).should_equal(true)
  end

  it.can "functions normally if both toggle and definitions inside a module_eval" do
    m = Module.new {
          eval <<-CODE
            module_function

            def test1() end
            def test2() end
          CODE
        }

    m.respond_to?(:test1).should_equal(true)
    m.respond_to?(:test2).should_equal(true)
  end
end
