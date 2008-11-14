# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#scan" do |it| 
  it.returns "an array containing all matches" do
    "cruel world".scan(/\w+/).should_equal(["cruel", "world"])
    "cruel world".scan(/.../).should_equal(["cru", "el ", "wor"])
    
    # Edge case
    "hello".scan(//).should_equal(["", "", "", "", "", ""])
    "".scan(//).should_equal([""])
  end
  
  it.will "store groups as arrays in the returned arrays" do
    "hello".scan(/()/).should_equal([[""]] * 6)
    "hello".scan(/()()/).should_equal([["", ""]] * 6)
    "cruel world".scan(/(...)/).should_equal([["cru"], ["el "], ["wor"]])
    "cruel world".scan(/(..)(..)/).should_equal([["cr", "ue"], ["l ", "wo"]])
  end
  
  it.will "scan for occurrences of the string if pattern is a string" do
    "one two one two".scan('one').should_equal(["one", "one"])
    "hello.".scan('.').should_equal(['.'])
  end

  it.will "set $~ to MatchData of last match and nil when there's none" do
    'hello.'.scan(/.(.)/)
    $~[0].should_equal('o.')

    'hello.'.scan(/not/)
    $~.should_equal(nil)

    'hello.'.scan('l')
    $~.begin(0).should_equal(3)
    $~[0].should_equal('l')

    'hello.'.scan('not')
    $~.should_equal(nil)
  end
  
  it.supports "\\G which matches the end of the previous match / string start for first match" do
    "one two one two".scan(/\G\w+/).should_equal(["one"])
    "one two one two".scan(/\G\w+\s*/).should_equal(["one ", "two ", "one ", "two"])
    "one two one two".scan(/\G\s*\w+/).should_equal(["one", " two", " one", " two"])
  end

  it.tries "to convert pattern to a string via to_str" do
    obj = mock('o')
    obj.should_receive(:to_str).and_return("o")
    "o_o".scan(obj).should_equal(["o", "o"])
    
    obj = mock('-')
    obj.should_receive(:respond_to?).with(:to_str).and_return(true)
    obj.should_receive(:method_missing).with(:to_str).and_return("-")
    "-_-".scan(obj).should_equal(["-", "-"])
  end
  
  it.raises " a TypeError if pattern isn't a Regexp and can't be converted to a String" do
    lambda { "cruel world".scan(5)         }.should_raise(TypeError)
    lambda { "cruel world".scan(:test)     }.should_raise(TypeError)
    lambda { "cruel world".scan(mock('x')) }.should_raise(TypeError)
  end
  
  # Note: MRI taints for tainted regexp patterns,
  # but not for tainted string patterns.
  # TODO: Report to ruby-core.
  it.will "taint the match strings if self is tainted, unless the taint happens in the method call" do
    deviates_on :ruby do
      a = "hello hello hello".scan("hello".taint)
      a.each { |m| m.tainted?.should_equal(false })
    end

    a = "hello hello hello".taint.scan("hello")
    a.each { |m| m.tainted?.should_equal(true })
    
    a = "hello".scan(/./.taint)
    a.each { |m| m.tainted?.should_equal(true })

    a = "hello".taint.scan(/./)
    a.each { |m| m.tainted?.should_equal(true }    )
  end
end

describe "String#scan with pattern and block" do |it| 
  it.returns "self" do
    s = "foo"
    s.scan(/./) {}.should_equal(s)
    s.scan(/roar/) {}.should_equal(s)
  end
  
  it.will "passe each match to the block as one argument: an array" do
    a = []
    "cruel world".scan(/\w+/) { |*w| a << w }
    a.should_equal([["cruel"], ["world"]])
  end
  
  it.will "passe groups to the block as one argument: an array" do
    a = []
    "cruel world".scan(/(..)(..)/) { |w| a << w }
    a.should_equal([["cr", "ue"], ["l ", "wo"]])
  end
  
  it.will "set $~ for access from the block" do
    str = "hello"

    matches = []
    offsets = []
    
    str.scan(/([aeiou])/) do
       md = $~
       md.string.should_equal(str)
       matches << md.to_a
       offsets << md.offset(0)
       str
    end
    
    matches.should_equal([["e", "e"], ["o", "o"]])
    offsets.should_equal([[1, 2], [4, 5]])

    matches = []
    offsets = []
    
    str.scan("l") do
       md = $~
       md.string.should_equal(str)
       matches << md.to_a
       offsets << md.offset(0)
       str
    end
    
    matches.should_equal([["l"], ["l"]])
    offsets.should_equal([[2, 3], [3, 4]])
  end
  
  it.will "restores $~ after leaving the block" do
    [/./, "l"].each do |pattern|
      old_md = nil
      "hello".scan(pattern) do
        old_md = $~
        "ok".match(/./)
        "x"
      end
    
      $~.should_equal(old_md)
      $~.string.should_equal("hello")
    end
  end
  
  it.will "set $~ to MatchData of last match and nil when there's none for access from outside" do
    'hello.'.scan('l') { 'x' }
    $~.begin(0).should_equal(3)
    $~[0].should_equal('l')

    'hello.'.scan('not') { 'x' }
    $~.should_equal(nil)

    'hello.'.scan(/.(.)/) { 'x' }
    $~[0].should_equal('o.')

    'hello.'.scan(/not/) { 'x' }
    $~.should_equal(nil)
  end
  
  # Note: MRI taints for tainted regexp patterns,
  # but not for tainted string patterns.
  # TODO: Report to ruby-core.
  it.will "taint the match strings if self is tainted, unless the tain happens inside the scan" do
    deviates_on :ruby do
      "hello hello hello".scan("hello".taint) { |m| m.tainted?.should_equal(false })
    end
    
    deviates_on :rubinius do
      "hello hello hello".scan("hello".taint) { |m| m.tainted?.should_equal(true })
    end

    "hello hello hello".taint.scan("hello") { |m| m.tainted?.should_equal(true })
    
    "hello".scan(/./.taint) { |m| m.tainted?.should_equal(true })
    "hello".taint.scan(/./) { |m| m.tainted?.should_equal(true })
  end
end
