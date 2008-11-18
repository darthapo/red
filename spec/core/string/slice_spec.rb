# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'
# require File.dirname(__FILE__) + '/shared/slice.rb'

describe "String#slice" do |it| 
  it.behaves_like :string_slice, :slice
end

describe "String#slice with index, length" do |it| 
  it.behaves_like :string_slice_index_length, :slice
end

describe "String#slice with Range" do |it| 
  it.behaves_like :string_slice_range, :slice
end

describe "String#slice with Regexp" do |it| 
  it.behaves_like :string_slice_regexp, :slice
end

describe "String#slice with Regexp, index" do |it| 
  it.behaves_like :string_slice_regexp_index, :slice
end

describe "String#slice with String" do |it| 
  it.behaves_like :string_slice_string, :slice
end

describe "String#slice! with index" do |it| 
  it.will "delete and return the char at the given position" do
    a = "hello"
    a.slice!(1).should_equal(?e)
    a.should_equal("hllo")
    a.slice!(-1).should_equal(?o)
    a.should_equal("hll")
  end
  
  it.returns "nil if idx is outside of self" do
    a = "hello"
    a.slice!(20).should_equal(nil)
    a.should_equal("hello")
    a.slice!(-20).should_equal(nil)
    a.should_equal("hello")
  end
  
  it.calls " to_int on index" do
    "hello".slice!(0.5).should_equal(?h)

    obj = mock('1')
    # MRI calls this twice so we can't use should_receive here.
    def obj.to_int() 1 end
    "hello".slice!(obj).should_equal(?e)

    obj = mock('1')
    def obj.respond_to?(name) name == :to_int ? true : super; end
    def obj.method_missing(name, *) name == :to_int ? 1 : super; end
    "hello".slice!(obj).should_equal(?e)
  end
end

describe "String#slice! with index, length" do |it| 
  it.will "delete and returns the substring at idx and the given length" do
    a = "hello"
    a.slice!(1, 2).should_equal("el")
    a.should_equal("hlo")

    a.slice!(1, 0).should_equal("")
    a.should_equal("hlo")

    a.slice!(-2, 4).should_equal("lo")
    a.should_equal("h")
  end

  it.will "always taint resulting strings when self is tainted" do
    str = "hello world"
    str.taint

    str.slice!(0, 0).tainted?.should_equal(true)
    str.slice!(2, 1).tainted?.should_equal(true)
  end

  it.returns "nil if the given position is out of self" do
    a = "hello"
    a.slice(10, 3).should_equal(nil)
    a.should_equal("hello")

    a.slice(-10, 20).should_equal(nil)
    a.should_equal("hello")
  end
  
  it.returns "nil if the length is negative" do
    a = "hello"
    a.slice(4, -3).should_equal(nil)
    a.should_equal("hello")
  end
  
  it.calls " to_int on idx and length" do
    "hello".slice!(0.5, 2.5).should_equal("he")

    obj = mock('2')
    def obj.to_int() 2 end
    "hello".slice!(obj, obj).should_equal("ll")

    obj = mock('2')
    def obj.respond_to?(name) name == :to_int; end
    def obj.method_missing(name, *) name == :to_int ? 2 : super; end
    "hello".slice!(obj, obj).should_equal("ll")
  end
  
  it.returns "subclass instances" do
    s = StringSpecs::MyString.new("hello")
    s.slice!(0, 0).class.should_equal(StringSpecs::MyString)
    s.slice!(0, 4).class.should_equal(StringSpecs::MyString)
  end
end

describe "String#slice! Range" do |it| 
  it.will "delete and return the substring given by the offsets of the range" do
    a = "hello"
    a.slice!(1..3).should_equal("ell")
    a.should_equal("ho")
    a.slice!(0..0).should_equal("h")
    a.should_equal("o")
    a.slice!(0...0).should_equal("")
    a.should_equal("o")
    
    # Edge Case?
    "hello".slice!(-3..-9).should_equal("")
  end
  
  it.returns "nil if the given range is out of self" do
    a = "hello"
    a.slice!(-6..-9).should_equal(nil)
    a.should_equal("hello")
    
    b = "hello"
    b.slice!(10..20).should_equal(nil)
    b.should_equal("hello")
  end
  
  it.will "always taint resulting strings when self is tainted" do
    str = "hello world"
    str.taint

    str.slice!(0..0).tainted?.should_equal(true)
    str.slice!(2..3).tainted?.should_equal(true)
  end

  it.returns "subclass instances" do
    s = StringSpecs::MyString.new("hello")
    s.slice!(0...0).class.should_equal(StringSpecs::MyString)
    s.slice!(0..4).class.should_equal(StringSpecs::MyString)
  end

  it.calls " to_int on range arguments" do
    from = mock('from')
    to = mock('to')

    # So we can construct a range out of them...
    def from.<=>(o) 0 end
    def to.<=>(o) 0 end

    def from.to_int() 1 end
    def to.to_int() -2 end

    "hello there".slice!(from..to).should_equal("ello ther")

    from = mock('from')
    to = mock('to')

    def from.<=>(o) 0 end
    def to.<=>(o) 0 end

    def from.respond_to?(name) name == :to_int; end
    def from.method_missing(name) name == :to_int ? 1 : super; end
    def to.respond_to?(name) name == :to_int; end
    def to.method_missing(name) name == :to_int ? -2 : super; end

    "hello there".slice!(from..to).should_equal("ello ther")
  end
  
  it.will "work with Range subclasses" do
    a = "GOOD"
    range_incl = StringSpecs::MyRange.new(1, 2)

    a.slice!(range_incl).should_equal("OO")
  end
end

describe "String#slice! with Regexp" do |it| 
  it.will "delete and returns the first match from self" do
    s = "this is a string"
    s.slice!(/s.*t/).should_equal('s is a st')
    s.should_equal('thiring')
    
    c = "hello hello"
    c.slice!(/llo/).should_equal("llo")
    c.should_equal("he hello")
  end
  
  it.returns "nil if there was no match" do
    s = "this is a string"
    s.slice!(/zzz/).should_equal(nil)
    s.should_equal("this is a string")
  end
  
  it.will "always taint resulting strings when self or regexp is tainted" do
    strs = ["hello world"]
    strs += strs.map { |s| s.dup.taint }

    strs.each do |str|
      str = str.dup
      str.slice!(//).tainted?.should_equal(str.tainted?)
      str.slice!(/hello/).tainted?.should_equal(str.tainted?)

      tainted_re = /./
      tainted_re.taint

      str.slice!(tainted_re).tainted?.should_equal(true)
    end
  end

  it.does_not " taint self when regexp is tainted" do
    s = "hello"
    s.slice!(/./.taint)
    s.tainted?.should_equal(false)
  end
  
  it.returns "subclass instances" do
    s = StringSpecs::MyString.new("hello")
    s.slice!(//).class.should_equal(StringSpecs::MyString)
    s.slice!(/../).class.should_equal(StringSpecs::MyString)
  end

  # This currently fails, but passes in a pure Rubinius environment (without mspec)
  # probably because mspec uses match internally for its operation
  it.will "set $~ to MatchData when there is a match and nil when there's none" do
    'hello'.slice!(/./)
    $~[0].should_equal('h')

    'hello'.slice!(/not/)
    $~.should_equal(nil)
  end
end

describe "String#slice! with Regexp, index" do |it| 
  it.will "delete and returns the capture for idx from self" do
    str = "hello there"
    str.slice!(/[aeiou](.)\1/, 0).should_equal("ell")
    str.should_equal("ho there")
    str.slice!(/(t)h/, 1).should_equal("t")
    str.should_equal("ho here")
  end

  it.will "always taint resulting strings when self or regexp is tainted" do
    strs = ["hello world"]
    strs += strs.map { |s| s.dup.taint }

    strs.each do |str|
      str = str.dup
      str.slice!(//, 0).tainted?.should_equal(str.tainted?)
      str.slice!(/hello/, 0).tainted?.should_equal(str.tainted?)

      tainted_re = /(.)(.)(.)/
      tainted_re.taint

      str.slice!(tainted_re, 1).tainted?.should_equal(true)
    end
  end
  
  it.does_not " taint self when regexp is tainted" do
    s = "hello"
    s.slice!(/(.)(.)/.taint, 1)
    s.tainted?.should_equal(false)
  end
  
  it.returns "nil if there was no match" do
    s = "this is a string"
    s.slice!(/x(zzz)/, 1).should_equal(nil)
    s.should_equal("this is a string")
  end
  
  it.returns "nil if there is no capture for idx" do
    "hello there".slice!(/[aeiou](.)\1/, 2).should_equal(nil)
    # You can't refer to 0 using negative indices
    "hello there".slice!(/[aeiou](.)\1/, -2).should_equal(nil)
  end

  it.calls " to_int on idx" do
    obj = mock('2')
    def obj.to_int() 2 end

    "har".slice!(/(.)(.)(.)/, 1.5).should_equal("h")
    "har".slice!(/(.)(.)(.)/, obj).should_equal("a")

    obj = mock('2')
    def obj.respond_to?(name) name == :to_int; end
    def obj.method_missing(name) name == :to_int ? 2: super; end
    "har".slice!(/(.)(.)(.)/, obj).should_equal("a")
  end
  
  it.returns "subclass instances" do
    s = StringSpecs::MyString.new("hello")
    s.slice!(/(.)(.)/, 0).class.should_equal(StringSpecs::MyString)
    s.slice!(/(.)(.)/, 1).class.should_equal(StringSpecs::MyString)
  end

  it.will "set $~ to MatchData when there is a match and nil when there's none" do
    'hello'[/.(.)/, 0]
    $~[0].should_equal('he')

    'hello'[/.(.)/, 1]
    $~[1].should_equal('e')

    'hello'[/not/, 0]
    $~.should_equal(nil)
  end
end

describe "String#slice! with String" do |it| 
  it.will "remove and returns the first occurrence of other_str from self" do
    c = "hello hello"
    c.slice!('llo').should_equal("llo")
    c.should_equal("he hello")
  end
  
  it.will "taint resulting strings when other is tainted" do
    strs = ["", "hello world", "hello"]
    strs += strs.map { |s| s.dup.taint }

    strs.each do |str|
      str = str.dup
      strs.each do |other|
        other = other.dup
        r = str.slice!(other)

        r.tainted?.should_equal(!r.nil? & other.tainted?)
      end
    end
  end
  
  it.does_not " set $~" do
    $~ = nil
    
    'hello'.slice!('ll')
    $~.should_equal(nil)
  end
  
  it.returns "nil if self does not contain other" do
    a = "hello"
    a.slice!('zzz').should_equal(nil)
    a.should_equal("hello")
  end
  
  it.does_not " call to_str on its argument" do
    o = mock('x')
    o.should_not_receive(:to_str)

    lambda { "hello".slice!(o) }.should_raise(TypeError)
  end

  it.returns "a subclass instance when given a subclass instance" do
    s = StringSpecs::MyString.new("el")
    r = "hello".slice!(s)
    r.should_equal("el")
    r.class.should_equal(StringSpecs::MyString)
  end

end
