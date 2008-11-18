# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Hash.[]" do |it| 
  it.creates "a Hash; values can be provided as the argument list" do
    Hash[:a, 1, :b, 2].should_equal({:a => 1, :b => 2})
    Hash[].should_equal({})
    Hash[:a, 1, :b, {:c => 2}].should_equal({:a => 1, :b => {:c => 2}})
  end

  it.creates "a Hash; values can be provided as one single hash" do
    Hash[:a => 1, :b => 2].should_equal({:a => 1, :b => 2})
    Hash[{1 => 2, 3 => 4}].should_equal({1 => 2, 3 => 4})
    Hash[{}].should_equal({})
  end

  it.raises " an ArgumentError when passed an odd number of arguments" do
    lambda { Hash[1, 2, 3] }.should_raise(ArgumentError)
    lambda { Hash[1, 2, {3 => 4}] }.should_raise(ArgumentError)
  end

  it.returns "an instance of the class it's called on" do
    Hash[MyHash[1, 2]].class.should_equal(Hash)
    MyHash[Hash[1, 2]].class.should_equal(MyHash)
  end
end

describe "Hash#[]" do |it| 
  it.returns "the value for key" do
    obj = mock('x')
    h = { 1 => 2, 3 => 4, "foo" => "bar", obj => obj, [] => "baz" }
    h[1].should_equal(2)
    h[3].should_equal(4)
    h["foo"].should_equal("bar")
    h[obj].should_equal(obj)
    h[[]].should_equal("baz")
  end

  it.returns "nil as default default value" do
    { 0 => 0 }[5].should_equal(nil)
  end

  it.returns "the default (immediate) value for missing keys" do
    h = Hash.new(5)
    h[:a].should_equal(5)
    h[:a] = 0
    h[:a].should_equal(0)
    h[:b].should_equal(5)
  end

  it.calls " subclass implementations of default" do
    h = DefaultHash.new
    h[:nothing].should_equal(100)
  end

  it.does_not "create copies of the immediate default value" do
    str = "foo"
    h = Hash.new(str)
    a = h[:a]
    b = h[:b]
    a << "bar"

    a.should_equal(b)
    a.should_equal("foobar")
    b.should_equal("foobar")
  end

  it.returns "the default (dynamic) value for missing keys" do
    h = Hash.new { |hsh, k| k.kind_of?(Numeric) ? hsh[k] = k + 2 : hsh[k] = k }
    h[1].should_equal(3)
    h['this'].should_equal('this')
    h.should_equal({1 => 3, 'this' => 'this'})

    i = 0
    h = Hash.new { |hsh, key| i += 1 }
    h[:foo].should_equal(1)
    h[:foo].should_equal(2)
    h[:bar].should_equal(3)
  end

  it.does_not "return default values for keys with nil values" do
    h = Hash.new(5)
    h[:a] = nil
    h[:a].should_equal(nil)

    h = Hash.new() { 5 }
    h[:a] = nil
    h[:a].should_equal(nil)
  end

  it.can "compare keys with eql? semantics" do
    { 1.0 => "x" }[1].should_equal(nil)
    { 1.0 => "x" }[1.0].should_equal("x")
    { 1 => "x" }[1.0].should_equal(nil)
    { 1 => "x" }[1].should_equal("x")
  end

  it.can "compare key via hash" do
    # Can't use should_receive because it uses hash internally
    x = mock('0')
    def x.hash() 0 end

    { }[x].should_equal(nil)
  end

  it.does_not "compare key with unknown hash codes via eql?" do
    # Can't use should_receive because it uses hash and eql? internally
    x = mock('x')
    y = mock('y')
    def x.eql?(o) raise("Shouldn't receive eql?") end

    def x.hash() 0 end
    def y.hash() 1 end

    { y => 1 }[x].should_equal(nil)
  end

  it.can "compare key with found hash code via eql?" do
    # Can't use should_receive because it uses hash and eql? internally
    y = mock('0')
    def y.hash() 0 end

    x = mock('0')
    def x.hash()
      def self.eql?(o) taint; false; end
      return 0
    end

    { y => 1 }[x].should_equal(nil)
    x.tainted?.should_equal(true)

    x = mock('0')
    def x.hash()
      def self.eql?(o) taint; true; end
      return 0
    end

    { y => 1 }[x].should_equal(1)
    x.tainted?.should_equal(true)
  end
end
