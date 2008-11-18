# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#sub with pattern, replacement" do |it| 
  it.returns "a copy of self with all occurrences of pattern replaced with replacement" do
    "hello".sub(/[aeiou]/, '*').should_equal("h*llo")
    "hello".sub(//, ".").should_equal(".hello")
  end

  it.will "ignore a block if supplied" do
    "food".sub(/f/, "g") { "w" }.should_equal("good")
  end

  it.supports "\\G which matches at the beginning of the string" do
    "hello world!".sub(/\Ghello/, "hi").should_equal("hi world!")
  end

  it.supports "/i for ignoring case" do
    "Hello".sub(/h/i, "j").should_equal("jello")
    "hello".sub(/H/i, "j").should_equal("jello")
  end

  it.does_not " interpret regexp metacharacters if pattern is a string" do
    "12345".sub('\d', 'a').should_equal("12345")
    '\d'.sub('\d', 'a').should_equal("a")
  end

  it.will "replace \\1 sequences with the regexp's corresponding capture" do
    str = "hello"

    str.sub(/([aeiou])/, '<\1>').should_equal("h<e>llo")
    str.sub(/(.)/, '\1\1').should_equal("hhello")

    str.sub(/.(.?)/, '<\0>(\1)').should_equal("<he>(e)llo")

    str.sub(/.(.)+/, '\1').should_equal("o")

    str = "ABCDEFGHIJKL"
    re = /#{"(.)" * 12}/
    str.sub(re, '\1').should_equal("A")
    str.sub(re, '\9').should_equal("I")
    # Only the first 9 captures can be accessed in MRI
    str.sub(re, '\10').should_equal("A0")
  end

  it.will "treat \\1 sequences without corresponding captures as empty strings" do
    str = "hello!"

    str.sub("", '<\1>').should_equal("<>hello!")
    str.sub("h", '<\1>').should_equal("<>ello!")

    str.sub(//, '<\1>').should_equal("<>hello!")
    str.sub(/./, '\1\2\3').should_equal("ello!")
    str.sub(/.(.{20})?/, '\1').should_equal("ello!")
  end

  it.will "replace \\& and \\0 with the complete match" do
    str = "hello!"

    str.sub("", '<\0>').should_equal("<>hello!")
    str.sub("", '<\&>').should_equal("<>hello!")
    str.sub("he", '<\0>').should_equal("<he>llo!")
    str.sub("he", '<\&>').should_equal("<he>llo!")
    str.sub("l", '<\0>').should_equal("he<l>lo!")
    str.sub("l", '<\&>').should_equal("he<l>lo!")

    str.sub(//, '<\0>').should_equal("<>hello!")
    str.sub(//, '<\&>').should_equal("<>hello!")
    str.sub(/../, '<\0>').should_equal("<he>llo!")
    str.sub(/../, '<\&>').should_equal("<he>llo!")
    str.sub(/(.)./, '<\0>').should_equal("<he>llo!")
  end

  it.will "replace \\` with everything before the current match" do
    str = "hello!"

    str.sub("", '<\`>').should_equal("<>hello!")
    str.sub("h", '<\`>').should_equal("<>ello!")
    str.sub("l", '<\`>').should_equal("he<he>lo!")
    str.sub("!", '<\`>').should_equal("hello<hello>")

    str.sub(//, '<\`>').should_equal("<>hello!")
    str.sub(/..o/, '<\`>').should_equal("he<he>!")
  end

  it.will "replace \\' with everything after the current match" do
    str = "hello!"

    str.sub("", '<\\\'>').should_equal("<hello!>hello!")
    str.sub("h", '<\\\'>').should_equal("<ello!>ello!")
    str.sub("ll", '<\\\'>').should_equal("he<o!>o!")
    str.sub("!", '<\\\'>').should_equal("hello<>")

    str.sub(//, '<\\\'>').should_equal("<hello!>hello!")
    str.sub(/../, '<\\\'>').should_equal("<llo!>llo!")
  end

  it.will "replace \\\\\\+ with \\\\+" do
    "x".sub(/x/, '\\\+').should_equal("\\+")
  end

  it.will "replace \\+ with the last paren that actually matched" do
    str = "hello!"

    str.sub(/(.)(.)/, '\+').should_equal("ello!")
    str.sub(/(.)(.)+/, '\+').should_equal("!")
    str.sub(/(.)()/, '\+').should_equal("ello!")
    str.sub(/(.)(.{20})?/, '<\+>').should_equal("<h>ello!")

    str = "ABCDEFGHIJKL"
    re = /#{"(.)" * 12}/
    str.sub(re, '\+').should_equal("L")
  end

  it.will "treat \\+ as an empty string if there was no captures" do
    "hello!".sub(/./, '\+').should_equal("ello!")
  end

  it.will "map \\\\ in replacement to \\" do
    "hello".sub(/./, '\\\\').should_equal('\\ello')
  end

  it.will "leave unknown \\x escapes in replacement untouched" do
    "hello".sub(/./, '\\x').should_equal('\\xello')
    "hello".sub(/./, '\\y').should_equal('\\yello')
  end

  it.will "leave \\ at the end of replacement untouched" do
    "hello".sub(/./, 'hah\\').should_equal('hah\\ello')
  end

  it.will "taint the result if the original string or replacement is tainted" do
    hello = "hello"
    hello_t = "hello"
    a = "a"
    a_t = "a"
    empty = ""
    empty_t = ""

    hello_t.taint; a_t.taint; empty_t.taint

    hello_t.sub(/./, a).tainted?.should_equal(true)
    hello_t.sub(/./, empty).tainted?.should_equal(true)

    hello.sub(/./, a_t).tainted?.should_equal(true)
    hello.sub(/./, empty_t).tainted?.should_equal(true)
    hello.sub(//, empty_t).tainted?.should_equal(true)

    hello.sub(//.taint, "foo").tainted?.should_equal(false)
  end

  it.tries "to convert pattern to a string using to_str" do
    pattern = mock('.')
    def pattern.to_str() "." end

    "hello.".sub(pattern, "!").should_equal("hello!")

    obj = mock('.')
    obj.should_receive(:respond_to?).with(:to_str).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_str).and_return(".")

    "hello.".sub(obj, "!").should_equal("hello!")
  end

  it.raises " a TypeError when pattern can't be converted to a string" do
    lambda { "hello".sub(:woot, "x") }.should_raise(TypeError)
    lambda { "hello".sub(?e, "x")    }.should_raise(TypeError)
  end

  it.tries "to convert replacement to a string using to_str" do
    replacement = mock('hello_replacement')
    def replacement.to_str() "hello_replacement" end

    "hello".sub(/hello/, replacement).should_equal("hello_replacement")

    obj = mock('ok')
    obj.should_receive(:respond_to?).with(:to_str).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_str).and_return("ok")
    "hello".sub(/hello/, obj).should_equal("ok")
  end

  it.raises " a TypeError when replacement can't be converted to a string" do
    lambda { "hello".sub(/[aeiou]/, :woot) }.should_raise(TypeError)
    lambda { "hello".sub(/[aeiou]/, ?f)    }.should_raise(TypeError)
  end

  it.returns "subclass instances when called on a subclass" do
    StringSpecs::MyString.new("").sub(//, "").class.should_equal(StringSpecs::MyString)
    StringSpecs::MyString.new("").sub(/foo/, "").class.should_equal(StringSpecs::MyString)
    StringSpecs::MyString.new("foo").sub(/foo/, "").class.should_equal(StringSpecs::MyString)
    StringSpecs::MyString.new("foo").sub("foo", "").class.should_equal(StringSpecs::MyString)
  end

  it.will "set $~ to MatchData of match and nil when there's none" do
    'hello.'.sub('hello', 'x')
    $~[0].should_equal('hello')

    'hello.'.sub('not', 'x')
    $~.should_equal(nil)

    'hello.'.sub(/.(.)/, 'x')
    $~[0].should_equal('he')

    'hello.'.sub(/not/, 'x')
    $~.should_equal(nil)
  end

  it.will 'replace \\\1 with \1' do
    "ababa".sub(/(b)/, '\\\1').should_equal("a\\1aba")
  end

  it.will 'replace \\\\1 with \\1' do
    "ababa".sub(/(b)/, '\\\\1').should_equal("a\\1aba")
  end

  it.will 'replace \\\\\1 with \\' do
    "ababa".sub(/(b)/, '\\\\\1').should_equal("a\\baba")
  end

end

describe "String#sub with pattern and block" do |it| 
  it.returns "a copy of self with the first occurrences of pattern replaced with the block's return value" do
    "hi".sub(/./) { |s| s[0].to_s + ' ' }.should_equal("104 i")
    "hi!".sub(/(.)(.)/) { |*a| a.inspect }.should_equal('["hi"]!')
  end

  it.will "set $~ for access from the block" do
    str = "hello"
    str.sub(/([aeiou])/) { "<#{$~[1]}>" }.should_equal("h<e>llo")
    str.sub(/([aeiou])/) { "<#{$1}>" }.should_equal("h<e>llo")
    str.sub("l") { "<#{$~[0]}>" }.should_equal("he<l>lo")

    offsets = []

    str.sub(/([aeiou])/) do
       md = $~
       md.string.should_equal(str)
       offsets << md.offset(0)
       str
    end.should_equal("hhellollo")

    offsets.should_equal([[1, 2]])
  end

  it.will "restore $~ after leaving the block" do
    [/./, "l"].each do |pattern|
      old_md = nil
      "hello".sub(pattern) do
        old_md = $~
        "ok".match(/./)
        "x"
      end

      $~.should_equal(old_md)
      $~.string.should_equal("hello")
    end
  end

  it.will "set $~ to MatchData of last match and nil when there's none for access from outside" do
    'hello.'.sub('l') { 'x' }
    $~.begin(0).should_equal(2)
    $~[0].should_equal('l')

    'hello.'.sub('not') { 'x' }
    $~.should_equal(nil)

    'hello.'.sub(/.(.)/) { 'x' }
    $~[0].should_equal('he')

    'hello.'.sub(/not/) { 'x' }
    $~.should_equal(nil)
  end

  it.does_not " raise a RuntimeError if the string is modified while substituting" do
    str = "hello"
    str.sub(//) { str[0] = 'x' }.should_equal("xhello")
    str.should_equal("xello")
  end

  it.does_not " interpolate special sequences like \\1 for the block's return value" do
    repl = '\& \0 \1 \` \\\' \+ \\\\ foo'
    "hello".sub(/(.+)/) { repl }.should_equal(repl)
  end

  it.can "convert the block's return value to a string using to_s" do
    obj = mock('hello_replacement')
    obj.should_receive(:to_s).and_return("hello_replacement")
    "hello".sub(/hello/) { obj }.should_equal("hello_replacement")

    obj = mock('ok')
    obj.should_receive(:to_s).and_return("ok")
    "hello".sub(/.+/) { obj }.should_equal("ok")
  end

  it.will "taint the result if the original string or replacement is tainted" do
    hello = "hello"
    hello_t = "hello"
    a = "a"
    a_t = "a"
    empty = ""
    empty_t = ""

    hello_t.taint; a_t.taint; empty_t.taint

    hello_t.sub(/./) { a }.tainted?.should_equal(true)
    hello_t.sub(/./) { empty }.tainted?.should_equal(true)

    hello.sub(/./) { a_t }.tainted?.should_equal(true)
    hello.sub(/./) { empty_t }.tainted?.should_equal(true)
    hello.sub(//) { empty_t }.tainted?.should_equal(true)

    hello.sub(//.taint) { "foo" }.tainted?.should_equal(false)
  end
end

describe "String#sub! with pattern, replacement" do |it| 
  it.will "modifyself in place and returns self" do
    a = "hello"
    a.sub!(/[aeiou]/, '*').should_equal(a)
    a.should_equal("h*llo")
  end

  it.will "taint self if replacement is tainted" do
    a = "hello"
    a.sub!(/./.taint, "foo").tainted?.should_equal(false)
    a.sub!(/./, "foo".taint).tainted?.should_equal(true)
  end

  it.returns "nil if no modifications were made" do
    a = "hello"
    a.sub!(/z/, '*').should_equal(nil)
    a.sub!(/z/, 'z').should_equal(nil)
    a.should_equal("hello")
  end

  compliant_on :ruby, :jruby do
    it.raises " a TypeError when self is frozen" do
      s = "hello"
      s.freeze

      s.sub!(/ROAR/, "x") # ok
      lambda { s.sub!(/e/, "e")       }.should_raise(TypeError)
      lambda { s.sub!(/[aeiou]/, '*') }.should_raise(TypeError)
    end
  end
end

describe "String#sub! with pattern and block" do |it| 
  it.will "modifyself in place and returns self" do
    a = "hello"
    a.sub!(/[aeiou]/) { '*' }.should_equal(a)
    a.should_equal("h*llo")
  end

  it.will "taint self if block's result is tainted" do
    a = "hello"
    a.sub!(/./.taint) { "foo" }.tainted?.should_equal(false)
    a.sub!(/./) { "foo".taint }.tainted?.should_equal(true)
  end

  it.returns "nil if no modifications were made" do
    a = "hello"
    a.sub!(/z/) { '*' }.should_equal(nil)
    a.sub!(/z/) { 'z' }.should_equal(nil)
    a.should_equal("hello")
  end
end
