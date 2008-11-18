# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#rindex with object" do |it| 
  it.raises " a TypeError if obj isn't a String, Fixnum or Regexp" do
    lambda { "hello".rindex(:sym)      }.should_raise(TypeError)    
    lambda { "hello".rindex(mock('x')) }.should_raise(TypeError)
  end

  it.does_not " try to convert obj to an integer via to_int" do
    obj = mock('x')
    obj.should_not_receive(:to_int)
    lambda { "hello".rindex(obj) }.should_raise(TypeError)
  end
end

describe "String#rindex with Fixnum" do |it| 
  it.returns "the index of the last occurrence of the given character" do
    "hello".rindex(?e).should_equal(1)
    "hello".rindex(?l).should_equal(3)
  end
  
  it.does_not " use fixnum % 256" do
    "hello".rindex(?e + 256 * 3).should_equal(nil)
    "hello".rindex(-(256 - ?e)).should_equal(nil)
  end
  
  it.will "start the search at the given offset" do
    "blablabla".rindex(?b, 0).should_equal(0)
    "blablabla".rindex(?b, 1).should_equal(0)
    "blablabla".rindex(?b, 2).should_equal(0)
    "blablabla".rindex(?b, 3).should_equal(3)
    "blablabla".rindex(?b, 4).should_equal(3)
    "blablabla".rindex(?b, 5).should_equal(3)
    "blablabla".rindex(?b, 6).should_equal(6)
    "blablabla".rindex(?b, 7).should_equal(6)
    "blablabla".rindex(?b, 8).should_equal(6)
    "blablabla".rindex(?b, 9).should_equal(6)
    "blablabla".rindex(?b, 10).should_equal(6)

    "blablabla".rindex(?a, 2).should_equal(2)
    "blablabla".rindex(?a, 3).should_equal(2)
    "blablabla".rindex(?a, 4).should_equal(2)
    "blablabla".rindex(?a, 5).should_equal(5)
    "blablabla".rindex(?a, 6).should_equal(5)
    "blablabla".rindex(?a, 7).should_equal(5)
    "blablabla".rindex(?a, 8).should_equal(8)
    "blablabla".rindex(?a, 9).should_equal(8)
    "blablabla".rindex(?a, 10).should_equal(8)
  end
  
  it.will "start the search at offset + self.length if offset is negative" do
    str = "blablabla"
    
    [?a, ?b].each do |needle|
      (-str.length .. -1).each do |offset|
        str.rindex(needle, offset).should ==
        str.rindex(needle, offset + str.length)
      end
    end
  end
  
  it.returns "nil if the character isn't found" do
    "hello".rindex(0).should_equal(nil)
    
    "hello".rindex(?H).should_equal(nil)
    "hello".rindex(?z).should_equal(nil)
    "hello".rindex(?o, 2).should_equal(nil)
    
    "blablabla".rindex(?a, 0).should_equal(nil)
    "blablabla".rindex(?a, 1).should_equal(nil)
    
    "blablabla".rindex(?a, -8).should_equal(nil)
    "blablabla".rindex(?a, -9).should_equal(nil)
    
    "blablabla".rindex(?b, -10).should_equal(nil)
    "blablabla".rindex(?b, -20).should_equal(nil)
  end
  
  it.tries "to convert start_offset to an integer via to_int" do
    obj = mock('5')
    def obj.to_int() 5 end
    "str".rindex(?s, obj).should_equal(0)
    
    obj = mock('5')
    def obj.respond_to?(arg) true end
    def obj.method_missing(*args); 5; end
    "str".rindex(?s, obj).should_equal(0)
  end
  
  it.raises " a TypeError when given offset is nil" do
    lambda { "str".rindex(?s, nil) }.should_raise(TypeError)
    lambda { "str".rindex(?t, nil) }.should_raise(TypeError)
  end
end

describe "String#rindex with String" do |it| 
  it.behaves "the same as String#rindex(char) for one-character strings" do
    ["blablabla", "hello cruel world...!"].each do |str|
      str.split("").uniq.each do |str|
        chr = str[0]
        str.rindex(str).should_equal(str.rindex(chr))
        
        0.upto(str.size + 1) do |start|
          str.rindex(str, start).should_equal(str.rindex(chr, start))
        end
        
        (-str.size - 1).upto(-1) do |start|
          str.rindex(str, start).should_equal(str.rindex(chr, start))
        end
      end
    end
  end
  
  it.returns "the index of the last occurrence of the given substring" do
    "blablabla".rindex("").should_equal(9)
    "blablabla".rindex("a").should_equal(8)
    "blablabla".rindex("la").should_equal(7)
    "blablabla".rindex("bla").should_equal(6)
    "blablabla".rindex("abla").should_equal(5)
    "blablabla".rindex("labla").should_equal(4)
    "blablabla".rindex("blabla").should_equal(3)
    "blablabla".rindex("ablabla").should_equal(2)
    "blablabla".rindex("lablabla").should_equal(1)
    "blablabla".rindex("blablabla").should_equal(0)
    
    "blablabla".rindex("l").should_equal(7)
    "blablabla".rindex("bl").should_equal(6)
    "blablabla".rindex("abl").should_equal(5)
    "blablabla".rindex("labl").should_equal(4)
    "blablabla".rindex("blabl").should_equal(3)
    "blablabla".rindex("ablabl").should_equal(2)
    "blablabla".rindex("lablabl").should_equal(1)
    "blablabla".rindex("blablabl").should_equal(0)

    "blablabla".rindex("b").should_equal(6)
    "blablabla".rindex("ab").should_equal(5)
    "blablabla".rindex("lab").should_equal(4)
    "blablabla".rindex("blab").should_equal(3)
    "blablabla".rindex("ablab").should_equal(2)
    "blablabla".rindex("lablab").should_equal(1)
    "blablabla".rindex("blablab").should_equal(0)
  end  
  
  it.does_not " set $~" do
    $~ = nil
    
    'hello.'.rindex('ll')
    $~.should_equal(nil)
  end
  
  it.will "ignore string subclasses" do
    "blablabla".rindex(StringSpecs::MyString.new("bla")).should_equal(6)
    StringSpecs::MyString.new("blablabla").rindex("bla").should_equal(6)
    StringSpecs::MyString.new("blablabla").rindex(StringSpecs::MyString.new("bla")).should_equal(6)
  end
  
  it.will "start the search at the given offset" do
    "blablabla".rindex("bl", 0).should_equal(0)
    "blablabla".rindex("bl", 1).should_equal(0)
    "blablabla".rindex("bl", 2).should_equal(0)
    "blablabla".rindex("bl", 3).should_equal(3)

    "blablabla".rindex("bla", 0).should_equal(0)
    "blablabla".rindex("bla", 1).should_equal(0)
    "blablabla".rindex("bla", 2).should_equal(0)
    "blablabla".rindex("bla", 3).should_equal(3)

    "blablabla".rindex("blab", 0).should_equal(0)
    "blablabla".rindex("blab", 1).should_equal(0)
    "blablabla".rindex("blab", 2).should_equal(0)
    "blablabla".rindex("blab", 3).should_equal(3)
    "blablabla".rindex("blab", 6).should_equal(3)
    "blablablax".rindex("blab", 6).should_equal(3)

    "blablabla".rindex("la", 1).should_equal(1)
    "blablabla".rindex("la", 2).should_equal(1)
    "blablabla".rindex("la", 3).should_equal(1)
    "blablabla".rindex("la", 4).should_equal(4)

    "blablabla".rindex("lab", 1).should_equal(1)
    "blablabla".rindex("lab", 2).should_equal(1)
    "blablabla".rindex("lab", 3).should_equal(1)
    "blablabla".rindex("lab", 4).should_equal(4)

    "blablabla".rindex("ab", 2).should_equal(2)
    "blablabla".rindex("ab", 3).should_equal(2)
    "blablabla".rindex("ab", 4).should_equal(2)
    "blablabla".rindex("ab", 5).should_equal(5)
    
    "blablabla".rindex("", 0).should_equal(0)
    "blablabla".rindex("", 1).should_equal(1)
    "blablabla".rindex("", 2).should_equal(2)
    "blablabla".rindex("", 7).should_equal(7)
    "blablabla".rindex("", 8).should_equal(8)
    "blablabla".rindex("", 9).should_equal(9)
    "blablabla".rindex("", 10).should_equal(9)
  end
  
  it.will "start the search at offset + self.length if offset is negative" do
    str = "blablabla"
    
    ["bl", "bla", "blab", "la", "lab", "ab", ""].each do |needle|
      (-str.length .. -1).each do |offset|
        str.rindex(needle, offset).should ==
        str.rindex(needle, offset + str.length)
      end
    end
  end

  it.returns "nil if the substring isn't found" do
    "blablabla".rindex("B").should_equal(nil)
    "blablabla".rindex("z").should_equal(nil)
    "blablabla".rindex("BLA").should_equal(nil)
    "blablabla".rindex("blablablabla").should_equal(nil)
        
    "hello".rindex("lo", 0).should_equal(nil)
    "hello".rindex("lo", 1).should_equal(nil)
    "hello".rindex("lo", 2).should_equal(nil)

    "hello".rindex("llo", 0).should_equal(nil)
    "hello".rindex("llo", 1).should_equal(nil)

    "hello".rindex("el", 0).should_equal(nil)
    "hello".rindex("ello", 0).should_equal(nil)
    
    "hello".rindex("", -6).should_equal(nil)
    "hello".rindex("", -7).should_equal(nil)

    "hello".rindex("h", -6).should_equal(nil)
  end
  
  it.tries "to convert start_offset to an integer via to_int" do
    obj = mock('5')
    def obj.to_int() 5 end
    "str".rindex("st", obj).should_equal(0)
    
    obj = mock('5')
    def obj.respond_to?(arg) true end
    def obj.method_missing(*args) 5 end
    "str".rindex("st", obj).should_equal(0)
  end

  it.raises " a TypeError when given offset is nil" do
    lambda { "str".rindex("st", nil) }.should_raise(TypeError)
  end
end

describe "String#rindex with Regexp" do |it| 
  it.behaves "the same as String#rindex(string) for escaped string regexps" do
    ["blablabla", "hello cruel world...!"].each do |str|
      ["", "b", "bla", "lab", "o c", "d."].each do |needle|
        regexp = Regexp.new(Regexp.escape(needle))
        str.rindex(regexp).should_equal(str.rindex(needle))
        
        0.upto(str.size + 1) do |start|
          str.rindex(regexp, start).should_equal(str.rindex(needle, start))
        end
        
        (-str.size - 1).upto(-1) do |start|
          str.rindex(regexp, start).should_equal(str.rindex(needle, start))
        end
      end
    end
  end
  
  it.returns "the index of the first match from the end of string of regexp" do
    "blablabla".rindex(/bla/).should_equal(6)
    "blablabla".rindex(/BLA/i).should_equal(6)

    "blablabla".rindex(/.{0}/).should_equal(9)
    "blablabla".rindex(/.{1}/).should_equal(8)
    "blablabla".rindex(/.{2}/).should_equal(7)
    "blablabla".rindex(/.{6}/).should_equal(3)
    "blablabla".rindex(/.{9}/).should_equal(0)

    "blablabla".rindex(/.*/).should_equal(9)
    "blablabla".rindex(/.+/).should_equal(8)

    "blablabla".rindex(/bla|a/).should_equal(8)
    
    "blablabla".rindex(/\A/).should_equal(0)
    "blablabla".rindex(/\Z/).should_equal(9)
    "blablabla".rindex(/\z/).should_equal(9)
    "blablabla\n".rindex(/\Z/).should_equal(10)
    "blablabla\n".rindex(/\z/).should_equal(10)

    "blablabla".rindex(/^/).should_equal(0)
    "\nblablabla".rindex(/^/).should_equal(1)
    "b\nlablabla".rindex(/^/).should_equal(2)
    "blablabla".rindex(/$/).should_equal(9)
    
    "blablabla".rindex(/.l./).should_equal(6)
  end
  
  it.will "set $~ to MatchData of match and nil when there's none" do
    'hello.'.rindex(/.(.)/)
    $~[0].should_equal('o.')

    'hello.'.rindex(/not/)
    $~.should_equal(nil)
  end
  
  it.will "start the search at the given offset" do
    "blablabla".rindex(/.{0}/, 5).should_equal(5)
    "blablabla".rindex(/.{1}/, 5).should_equal(5)
    "blablabla".rindex(/.{2}/, 5).should_equal(5)
    "blablabla".rindex(/.{3}/, 5).should_equal(5)
    "blablabla".rindex(/.{4}/, 5).should_equal(5)

    "blablabla".rindex(/.{0}/, 3).should_equal(3)
    "blablabla".rindex(/.{1}/, 3).should_equal(3)
    "blablabla".rindex(/.{2}/, 3).should_equal(3)
    "blablabla".rindex(/.{5}/, 3).should_equal(3)
    "blablabla".rindex(/.{6}/, 3).should_equal(3)

    "blablabla".rindex(/.l./, 0).should_equal(0)
    "blablabla".rindex(/.l./, 1).should_equal(0)
    "blablabla".rindex(/.l./, 2).should_equal(0)
    "blablabla".rindex(/.l./, 3).should_equal(3)
    
    "blablablax".rindex(/.x/, 10).should_equal(8)
    "blablablax".rindex(/.x/, 9).should_equal(8)
    "blablablax".rindex(/.x/, 8).should_equal(8)

    "blablablax".rindex(/..x/, 10).should_equal(7)
    "blablablax".rindex(/..x/, 9).should_equal(7)
    "blablablax".rindex(/..x/, 8).should_equal(7)
    "blablablax".rindex(/..x/, 7).should_equal(7)
    
    "blablabla\n".rindex(/\Z/, 9).should_equal(9)
  end
  
  it.will "start the search at offset + self.length if offset is negative" do
    str = "blablabla"
    
    ["bl", "bla", "blab", "la", "lab", "ab", ""].each do |needle|
      (-str.length .. -1).each do |offset|
        str.rindex(needle, offset).should ==
        str.rindex(needle, offset + str.length)
      end
    end
  end

  it.returns "nil if the substring isn't found" do
    "blablabla".rindex(/BLA/).should_equal(nil)
    "blablabla".rindex(/.{10}/).should_equal(nil)
    "blablablax".rindex(/.x/, 7).should_equal(nil)
    "blablablax".rindex(/..x/, 6).should_equal(nil)
    
    "blablabla".rindex(/\Z/, 5).should_equal(nil)
    "blablabla".rindex(/\z/, 5).should_equal(nil)
    "blablabla\n".rindex(/\z/, 9).should_equal(nil)
  end

  it.supports "\\G which matches at the given start offset" do
    "helloYOU.".rindex(/YOU\G/, 8).should_equal(5)
    "helloYOU.".rindex(/YOU\G/).should_equal(nil)

    idx = "helloYOUall!".index("YOU")
    re = /YOU.+\G.+/
    # The # marks where \G will match.
    [
      ["helloYOU#all.", nil],
      ["helloYOUa#ll.", idx],
      ["helloYOUal#l.", idx],
      ["helloYOUall#.", idx],
      ["helloYOUall.#", nil]
    ].each do |i|
      start = i[0].index("#")
      str = i[0].delete("#")

      str.rindex(re, start).should_equal(i[1])
    end
  end
  
  it.tries "to convert start_offset to an integer via to_int" do
    obj = mock('5')
    def obj.to_int() 5 end
    "str".rindex(/../, obj).should_equal(1)
    
    obj = mock('5')
    def obj.respond_to?(arg) true end
    def obj.method_missing(*args); 5; end
    "str".rindex(/../, obj).should_equal(1)
  end

  it.raises " a TypeError when given offset is nil" do
    lambda { "str".rindex(/../, nil) }.should_raise(TypeError)
  end
end
