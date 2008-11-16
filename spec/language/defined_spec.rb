# require File.dirname(__FILE__) + '/../spec_helper'

describe "The defined? keyword" do |it| 
  class LanguageDefinedSpecs
    SomeConst = 5

    def no_args
    end
    def args(x)
    end

    def lvar_defined
      x = 1
      defined?(x)
    end
  end
  
  class LanguageDefinedSubclass < LanguageDefinedSpecs
    def no_args
      defined?(super)
    end
    def args
      defined?( super() )
    end
  end

  module AAA
    self::FOO = 'x' unless defined? self::FOO rescue nil
  end
  
  it.returns "'method' when defined?(exit) is sent" do
    ret = defined?(exit)
    ret.should_equal('method')
  end

  it.returns "'method' when defined?(Kernel.puts) is sent (attribute)" do
    ret = defined?(Kernel.puts)
    ret.should_equal('method')
  end

  it.returns "nil when defined?(DoesNotExist.puts) is sent" do
    ret = defined?(DoesNotExist.puts)
    ret.should_equal(nil)
  end

  it.returns "nil when defined?(Kernel.does_not_exist) is sent" do
    ret = defined?(Kernel.does_not_exist)
    ret.should_equal(nil)
  end

  it.returns "'assignment' when defined?(x = 2) is sent" do
    ret = defined?(x = 2)
    ret.should_equal('assignment')
  end

  it.returns "'local-variable' when x = 1; defined?(x) is sent" do
    obj = LanguageDefinedSpecs.new
    obj.lvar_defined.should_equal('local-variable')
  end

  it.returns "'constant' when defined?(Object) is sent" do
    ret = defined?(Object)
    ret.should_equal('constant')
  end

  it.returns "'class variable' when @@x = 1; defined?(@@x) is sent" do
    @@x = 1
    ret = defined?(@@x)
    ret.should_equal('class variable')
  end

  it.returns "'instance-variable' when @x = 1; defined?(@x) is sent" do
    @x = 1
    ret = defined?(@x)
    ret.should_equal('instance-variable')
  end

  it.returns "'global-variable' when $x = 1; defined?($x) is sent" do
    $x = 1
    ret = defined?($x)
    ret.should_equal('global-variable')
  end

  it.returns "'expression' when defined?('foo = bar') is sent" do
    ret = defined?('foo = bar')
    ret.should_equal("expression")
  end

  it.returns "'self' when defined?(self) is sent" do
    ret = defined?(self)
    ret.should_equal("self")
  end

  it.returns "'nil' when defined?(nil) is sent" do
    ret = defined?(nil)
    ret.should_equal("nil")
  end

  it.returns "'true' when defined?(true) is sent" do
    ret = defined?(true)
    ret.should_equal("true")
  end

  it.returns "'false' when defined?(false) is sent" do
    ret = defined?(false)
    ret.should_equal("false")
  end

  it.returns "nil when defined?(no_such_local) is sent" do
    ret = defined?(no_such_local)
    ret.should_equal(nil)
  end

  it.returns "'expression' when defined?(:File) is sent" do
    ret = defined?(:File)
    ret.should_equal("expression")
  end

  it.returns "'constant' when defined?(LanguageDefinedSpecs::SomeConst) is sent" do
    ret = defined?(LanguageDefinedSpecs::SomeConst)
    ret.should_equal("constant")
  end

  it.returns "'constant' when evaluating self::FOO in module AAA" do
    ret = defined?(AAA::FOO)
    ret.should_equal('constant')
  end

  it.returns "'constant' when defined?(File) is sent" do
    ret = defined?(File)
    ret.should_equal("constant")
  end

  it.returns "'constant' when defined?(File::SEPARATOR) is sent" do
    ret = defined?(File::SEPARATOR)
    ret.should_equal("constant")
  end

  it.returns "'method' when defined?(Object.nil?) is sent" do
    ret = defined?(Object.nil?)
    ret.should_equal("method")
  end

  it.returns "'expression' when defined?(0) is sent" do
    ret = defined?(0)
    ret.should_equal("expression")
  end

  compliant_on :rubinius do
    # Rubinius does not care about dynamic vars
    it.returns "'local-variable' when defined? is called on a block var" do
      block = Proc.new { |x| defined?(x) }
      ret = block.call(1)
      ret.should_equal('local-variable')
    end
  end
end

