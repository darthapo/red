# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#gsub with pattern and replacement" do |it| 

  it.does_not " freak out when replacing ^" do
    "Text\n".gsub(/^/, ' ').should_equal(" Text\n")
    "Text\nFoo".gsub(/^/, ' ').should_equal(" Text\n Foo")
  end

  it.returns "a copy of self with all occurrences of pattern replaced with replacement" do
    "hello".gsub(/[aeiou]/, '*').should_equal("h*ll*")

    str = "hello homely world. hah!"
    str.gsub(/\Ah\S+\s*/, "huh? ").should_equal("huh? homely world. hah!")

    "hello".gsub(//, ".").should_equal(".h.e.l.l.o.")
  end
  
  it.will "ignore a block if supplied" do
    "food".gsub(/f/, "g") { "w" }.should_equal("good")
  end

  it.supports "\\G which matches at the beginning of the remaining (non-matched) string" do
    str = "hello homely world. hah!"
    str.gsub(/\Gh\S+\s*/, "huh? ").should_equal("huh? huh? world. hah!")
  end
  
  it.supports "/i for ignoring case" do
    str = "Hello. How happy are you?"
    str.gsub(/h/i, "j").should_equal("jello. jow jappy are you?")
    str.gsub(/H/i, "j").should_equal("jello. jow jappy are you?")
  end
  
  it.does_not " interpret regexp metacharacters if pattern is a string" do
    "12345".gsub('\d', 'a').should_equal("12345")
    '\d'.gsub('\d', 'a').should_equal("a")
  end
  
  it.will "replace \\1 sequences with the regexp's corresponding capture" do
    str = "hello"
    
    str.gsub(/([aeiou])/, '<\1>').should_equal("h<e>ll<o>")
    str.gsub(/(.)/, '\1\1').should_equal("hheelllloo")

    str.gsub(/.(.?)/, '<\0>(\1)').should_equal("<he>(e)<ll>(l)<o>()")

    str.gsub(/.(.)+/, '\1').should_equal("o")

    str = "ABCDEFGHIJKLabcdefghijkl"
    re = /#{"(.)" * 12}/
    str.gsub(re, '\1').should_equal("Aa")
    str.gsub(re, '\9').should_equal("Ii")
    # Only the first 9 captures can be accessed in MRI
    str.gsub(re, '\10').should_equal("A0a0")
  end

  it.will "treat \\1 sequences without corresponding captures as empty strings" do
    str = "hello!"
    
    str.gsub("", '<\1>').should_equal("<>h<>e<>l<>l<>o<>!<>")
    str.gsub("h", '<\1>').should_equal("<>ello!")

    str.gsub(//, '<\1>').should_equal("<>h<>e<>l<>l<>o<>!<>")
    str.gsub(/./, '\1\2\3').should_equal("")
    str.gsub(/.(.{20})?/, '\1').should_equal("")
  end

  it.will "replace \\& and \\0 with the complete match" do
    str = "hello!"
    
    str.gsub("", '<\0>').should_equal("<>h<>e<>l<>l<>o<>!<>")
    str.gsub("", '<\&>').should_equal("<>h<>e<>l<>l<>o<>!<>")
    str.gsub("he", '<\0>').should_equal("<he>llo!")
    str.gsub("he", '<\&>').should_equal("<he>llo!")
    str.gsub("l", '<\0>').should_equal("he<l><l>o!")
    str.gsub("l", '<\&>').should_equal("he<l><l>o!")
    
    str.gsub(//, '<\0>').should_equal("<>h<>e<>l<>l<>o<>!<>")
    str.gsub(//, '<\&>').should_equal("<>h<>e<>l<>l<>o<>!<>")
    str.gsub(/../, '<\0>').should_equal("<he><ll><o!>")
    str.gsub(/../, '<\&>').should_equal("<he><ll><o!>")
    str.gsub(/(.)./, '<\0>').should_equal("<he><ll><o!>")
  end

  it.will "replace \\` with everything before the current match" do
    str = "hello!"
    
    str.gsub("", '<\`>').should_equal("<>h<h>e<he>l<hel>l<hell>o<hello>!<hello!>")
    str.gsub("h", '<\`>').should_equal("<>ello!")
    str.gsub("l", '<\`>').should_equal("he<he><hel>o!")
    str.gsub("!", '<\`>').should_equal("hello<hello>")
    
    str.gsub(//, '<\`>').should_equal("<>h<h>e<he>l<hel>l<hell>o<hello>!<hello!>")
    str.gsub(/../, '<\`>').should_equal("<><he><hell>")
  end

  it.will "replace \\' with everything after the current match" do
    str = "hello!"
    
    str.gsub("", '<\\\'>').should_equal("<hello!>h<ello!>e<llo!>l<lo!>l<o!>o<!>!<>")
    str.gsub("h", '<\\\'>').should_equal("<ello!>ello!")
    str.gsub("ll", '<\\\'>').should_equal("he<o!>o!")
    str.gsub("!", '<\\\'>').should_equal("hello<>")
    
    str.gsub(//, '<\\\'>').should_equal("<hello!>h<ello!>e<llo!>l<lo!>l<o!>o<!>!<>")
    str.gsub(/../, '<\\\'>').should_equal("<llo!><o!><>")
  end
  
  it.will "replace \\+ with the last paren that actually matched" do
    str = "hello!"
    
    str.gsub(/(.)(.)/, '\+').should_equal("el!")
    str.gsub(/(.)(.)+/, '\+').should_equal("!")
    str.gsub(/(.)()/, '\+').should_equal("")
    str.gsub(/(.)(.{20})?/, '<\+>').should_equal("<h><e><l><l><o><!>")

    str = "ABCDEFGHIJKLabcdefghijkl"
    re = /#{"(.)" * 12}/
    str.gsub(re, '\+').should_equal("Ll")
  end

  it.will "treat \\+ as an empty string if there was no captures" do
    "hello!".gsub(/./, '\+').should_equal("")
  end
  
  it.will "map \\\\ in replacement to \\" do
    "hello".gsub(/./, '\\\\').should_equal('\\' * 5)
  end

  it.will "leave unknown \\x escapes in replacement untouched" do
    "hello".gsub(/./, '\\x').should_equal('\\x' * 5)
    "hello".gsub(/./, '\\y').should_equal('\\y' * 5)
  end

  it.will "leave \\ at the end of replacement untouched" do
    "hello".gsub(/./, 'hah\\').should_equal('hah\\' * 5)
  end
  
  it.will "taint the result if the original string or replacement is tainted" do
    hello = "hello"
    hello_t = "hello"
    a = "a"
    a_t = "a"
    empty = ""
    empty_t = ""
    
    hello_t.taint; a_t.taint; empty_t.taint
    
    hello_t.gsub(/./, a).tainted?.should_equal(true)
    hello_t.gsub(/./, empty).tainted?.should_equal(true)

    hello.gsub(/./, a_t).tainted?.should_equal(true)
    hello.gsub(/./, empty_t).tainted?.should_equal(true)
    hello.gsub(//, empty_t).tainted?.should_equal(true)
    
    hello.gsub(//.taint, "foo").tainted?.should_equal(false)
  end

  it.tries "to convert pattern to a string using to_str" do
    pattern = mock('.')
    def pattern.to_str() "." end
    
    "hello.".gsub(pattern, "!").should_equal("hello!")
  end

  it.raises " a TypeError when pattern can't be converted to a string" do
    lambda { "hello".gsub(:woot, "x") }.should_raise(TypeError)
    lambda { "hello".gsub(?e, "x")    }.should_raise(TypeError)
  end
  
  it.tries "to convert replacement to a string using to_str" do
    replacement = mock('hello_replacement')
    def replacement.to_str() "hello_replacement" end
    
    "hello".gsub(/hello/, replacement).should_equal("hello_replacement")
  end
  
  it.raises " a TypeError when replacement can't be converted to a string" do
    lambda { "hello".gsub(/[aeiou]/, :woot) }.should_raise(TypeError)
    lambda { "hello".gsub(/[aeiou]/, ?f)    }.should_raise(TypeError)
  end
  
  it.returns "subclass instances when called on a subclass" do
    StringSpecs::MyString.new("").gsub(//, "").class.should_equal(StringSpecs::MyString)
    StringSpecs::MyString.new("").gsub(/foo/, "").class.should_equal(StringSpecs::MyString)
    StringSpecs::MyString.new("foo").gsub(/foo/, "").class.should_equal(StringSpecs::MyString)
    StringSpecs::MyString.new("foo").gsub("foo", "").class.should_equal(StringSpecs::MyString)
  end

  # Note: $~ cannot be tested because mspec messes with it
  
  it.will "set $~ to MatchData of last match and nil when there's none" do
    'hello.'.gsub('hello', 'x')
    $~[0].should_equal('hello')
  
    'hello.'.gsub('not', 'x')
    $~.should_equal(nil)
  
    'hello.'.gsub(/.(.)/, 'x')
    $~[0].should_equal('o.')
  
    'hello.'.gsub(/not/, 'x')
    $~.should_equal(nil)
  end
end

describe "String#gsub with pattern and block" do |it| 
  it.returns "a copy of self with all occurrences of pattern replaced with the block's return value" do
    "hello".gsub(/./) { |s| s.succ + ' ' }.should_equal("i f m m p ")
    "hello!".gsub(/(.)(.)/) { |*a| a.inspect }.should_equal('["he"]["ll"]["o!"]')
    "hello".gsub('l') { 'x'}.should_equal('hexxo')
  end
  
  it.will "set $~ for access from the block" do
    str = "hello"
    str.gsub(/([aeiou])/) { "<#{$~[1]}>" }.should_equal("h<e>ll<o>")
    str.gsub(/([aeiou])/) { "<#{$1}>" }.should_equal("h<e>ll<o>")
    str.gsub("l") { "<#{$~[0]}>" }.should_equal("he<l><l>o")
    
    offsets = []
    
    str.gsub(/([aeiou])/) do
      md = $~
      md.string.should_equal(str)
      offsets << md.offset(0)
      str
    end.should_equal("hhellollhello")
    
    offsets.should_equal([[1, 2], [4, 5]])
  end
  
  it.will "restore $~ after leaving the block" do
    [/./, "l"].each do |pattern|
      old_md = nil
      "hello".gsub(pattern) do
        old_md = $~
        "ok".match(/./)
        "x"
      end

      $~.should_equal(old_md)
      $~.string.should_equal("hello")
    end
  end

  it.will "set $~ to MatchData of last match and nil when there's none for access from outside" do
    'hello.'.gsub('l') { 'x' }
    $~.begin(0).should_equal(3)
    $~[0].should_equal('l')

    'hello.'.gsub('not') { 'x' }
    $~.should_equal(nil)

    'hello.'.gsub(/.(.)/) { 'x' }
    $~[0].should_equal('o.')

    'hello.'.gsub(/not/) { 'x' }
    $~.should_equal(nil)
  end

  it.raises " a RuntimeError if the string is modified while substituting" do
    str = "hello"
    lambda { str.gsub(//) { str[0] = 'x' } }.should_raise(RuntimeError)
  end
  
  it.does_not " interpolate special sequences like \\1 for the block's return value" do
    repl = '\& \0 \1 \` \\\' \+ \\\\ foo'
    "hello".gsub(/(.+)/) { repl }.should_equal(repl)
  end
  
  it.can "convert the block's return value to a string using to_s" do
    replacement = mock('hello_replacement')
    def replacement.to_s() "hello_replacement" end
    
    "hello".gsub(/hello/) { replacement }.should_equal("hello_replacement")
    
    obj = mock('ok')
    def obj.to_s() "ok" end
    
    "hello".gsub(/.+/) { obj }.should_equal("ok")
  end
  
  it.will "taint the result if the original string or replacement is tainted" do
    hello = "hello"
    hello_t = "hello"
    a = "a"
    a_t = "a"
    empty = ""
    empty_t = ""
    
    hello_t.taint; a_t.taint; empty_t.taint
    
    hello_t.gsub(/./) { a }.tainted?.should_equal(true)
    hello_t.gsub(/./) { empty }.tainted?.should_equal(true)

    hello.gsub(/./) { a_t }.tainted?.should_equal(true)
    hello.gsub(/./) { empty_t }.tainted?.should_equal(true)
    hello.gsub(//) { empty_t }.tainted?.should_equal(true)
    
    hello.gsub(//.taint) { "foo" }.tainted?.should_equal(false)
  end  
end

describe "String#gsub! with pattern and replacement" do |it| 
  it.will "modifyself in place and returns self" do
    a = "hello"
    a.gsub!(/[aeiou]/, '*').should_equal(a)
    a.should_equal("h*ll*")
  end

  it.will "taint self if replacement is tainted" do
    a = "hello"
    a.gsub!(/./.taint, "foo").tainted?.should_equal(false)
    a.gsub!(/./, "foo".taint).tainted?.should_equal(true)
  end
  
  it.returns "nil if no modifications were made" do
    a = "hello"
    a.gsub!(/z/, '*').should_equal(nil)
    a.gsub!(/z/, 'z').should_equal(nil)
    a.should_equal("hello")
  end
end

describe "String#gsub! with pattern and block" do |it| 
  it.will "modifyself in place and returns self" do
    a = "hello"
    a.gsub!(/[aeiou]/) { '*' }.should_equal(a)
    a.should_equal("h*ll*")
  end

  it.will "taint self if block's result is tainted" do
    a = "hello"
    a.gsub!(/./.taint) { "foo" }.tainted?.should_equal(false)
    a.gsub!(/./) { "foo".taint }.tainted?.should_equal(true)
  end
  
  it.returns "nil if no modifications were made" do
    a = "hello"
    a.gsub!(/z/) { '*' }.should_equal(nil)
    a.gsub!(/z/) { 'z' }.should_equal(nil)
    a.should_equal("hello")
  end
end
