# require File.dirname(__FILE__) + '/../spec_helper'

describe "A Symbol literal" do |it| 
  it.is_a " ':' followed by any number of valid characters" do
    a = :foo
    a.should_be_kind_of(Symbol)
    a.inspect.should_equal(':foo')
  end

  it.is_a " ':' followed by any valid variable, method, or constant name" do
    # Add more of these?
    [ :Foo,
      :foo,
      :@foo,
      :@@foo,
      :$foo,
      :_,
      :~,
      :- ,
      :FOO,
      :_Foo,
      :&,
      :_9
    ].each { |s| s.should_be_kind_of(Symbol) }
  end

  it.is_a " ':' followed by a single- or double-quoted string that may contain otherwise invalid characters" do
    [ [:'foo bar',      ':"foo bar"'],
      [:'++',           ':"++"'],
      [:'9',            ':"9"'],
      [:"foo #{1 + 1}", ':"foo 2"'],
    ].each { |sym, str| 
      sym.should_be_kind_of(Symbol)
      sym.inspect.should_equal(str)
    }
  end

  it.can "may contain '::' in the string" do
    :'Some::Class'.should_be_kind_of(Symbol)
  end

  it.is "converted to a literal, unquoted representation if the symbol contains only valid characters" do
    a, b, c = :'foo', :'+', :'Foo__9'
    a.class.should_equal(Symbol)
    a.inspect.should_equal(':foo')
    b.class.should_equal(Symbol)
    b.inspect.should_equal(':+')
    c.class.should_equal(Symbol)
    c.inspect.should_equal(':Foo__9')
  end

  it.can "must not be an empty string" do
    lambda { eval ":''" }.should_raise(SyntaxError)
  end

  it.can "can be created by the %s-delimited expression" do
    a, b = :'foo bar', %s{foo bar}
    b.class.should_equal(Symbol)
    b.inspect.should_equal(':"foo bar"')
    b.should_equal(a)
  end

  it.is "the same object when created from identical strings" do
    var = "@@var"
    [ [:symbol, :symbol],
      [:'a string', :'a string'],
      [:"#{var}", :"#{var}"]
    ].each { |a, b|
      a.should_equal(b)
    }
  end
end
