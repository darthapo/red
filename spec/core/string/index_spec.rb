# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#index with object" do |it| 
  it.raises " a TypeError if obj isn't a String, Fixnum or Regexp" do
    lambda { "hello".index(:sym)      }.should_raise(TypeError)    
    lambda { "hello".index(mock('x')) }.should_raise(TypeError)
  end

  it.does_not " try to convert obj to an Integer via to_int" do
    obj = mock('x')
    obj.should_not_receive(:to_int)
    lambda { "hello".index(obj) }.should_raise(TypeError)
  end

  it.tries "to convert obj to a string via to_str" do
    obj = mock('lo')
    obj.should_receive(:respond_to?).with(:to_str).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_str).and_return("lo")
    "hello".index(obj).should_equal("hello".index("lo"))
    
    obj = mock('o')
    obj.should_receive(:respond_to?).with(:to_str).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_str).and_return("o")
    "hello".index(obj).should_equal("hello".index("o"))
  end
end

describe "String#index with Fixnum" do |it| 
  it.returns "the index of the first occurrence of the given character" do
    "hello".index(?e).should_equal(1)
    "hello".index(?l).should_equal(2)
  end
  
  it.can "character values over 255 (256th ASCII character) always result in nil" do
    # A naive implementation could try to use % 256
    "hello".index(?e + 256 * 3).should_equal(nil)
  end

  it.can "negative character values always result in nil" do
    # A naive implementation could try to use % 256
    "hello".index(-(256 - ?e)).should_equal(nil)
  end
  
  it.can "start the search at the given offset" do
    "blablabla".index(?b, 0).should_equal(0)
    "blablabla".index(?b, 1).should_equal(3)
    "blablabla".index(?b, 2).should_equal(3)
    "blablabla".index(?b, 3).should_equal(3)
    "blablabla".index(?b, 4).should_equal(6)
    "blablabla".index(?b, 5).should_equal(6)
    "blablabla".index(?b, 6).should_equal(6)

    "blablabla".index(?a, 0).should_equal(2)
    "blablabla".index(?a, 2).should_equal(2)
    "blablabla".index(?a, 3).should_equal(5)
    "blablabla".index(?a, 4).should_equal(5)
    "blablabla".index(?a, 5).should_equal(5)
    "blablabla".index(?a, 6).should_equal(8)
    "blablabla".index(?a, 7).should_equal(8)
    "blablabla".index(?a, 8).should_equal(8)
  end
  
  it.can "start the search at offset + self.length if offset is negative" do
    str = "blablabla"
    
    [?a, ?b].each do |needle|
      (-str.length .. -1).each do |offset|
        str.index(needle, offset).should ==
        str.index(needle, offset + str.length)
      end
    end

    "blablabla".index(?b, -9).should_equal(0)
  end
  
  it.returns "nil if offset + self.length is < 0 for negative offsets" do
    "blablabla".index(?b, -10).should_equal(nil)
    "blablabla".index(?b, -20).should_equal(nil)
  end
  
  it.returns "nil if the character isn't found" do
    "hello".index(0).should_equal(nil)
    
    "hello".index(?H).should_equal(nil)
    "hello".index(?z).should_equal(nil)
    "hello".index(?e, 2).should_equal(nil)

    "blablabla".index(?b, 7).should_equal(nil)
    "blablabla".index(?b, 10).should_equal(nil)

    "blablabla".index(?a, 9).should_equal(nil)
    "blablabla".index(?a, 20).should_equal(nil)
  end
  
  it.can "convert start_offset to an integer via to_int" do
    obj = mock('1')
    obj.should_receive(:to_int).and_return(1)
    "ROAR".index(?R, obj).should_equal(3)
    
    obj = mock('1')
    obj.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_int).and_return(1)
    "ROAR".index(?R, obj).should_equal(3)
  end
end

describe "String#index with String" do |it| 
  it.will "behave the same as String#index(char) for one-character strings" do
    ["blablabla", "hello cruel world...!"].each do |str|
      str.split("").uniq.each do |str|
        chr = str[0]
        str.index(str).should_equal(str.index(chr))
        
        0.upto(str.size + 1) do |start|
          str.index(str, start).should_equal(str.index(chr, start))
        end
        
        (-str.size - 1).upto(-1) do |start|
          str.index(str, start).should_equal(str.index(chr, start))
        end
      end
    end
  end
  
  it.returns "the index of the first occurrence of the given substring" do
    "blablabla".index("").should_equal(0)
    "blablabla".index("b").should_equal(0)
    "blablabla".index("bla").should_equal(0)
    "blablabla".index("blabla").should_equal(0)
    "blablabla".index("blablabla").should_equal(0)

    "blablabla".index("l").should_equal(1)
    "blablabla".index("la").should_equal(1)
    "blablabla".index("labla").should_equal(1)
    "blablabla".index("lablabla").should_equal(1)

    "blablabla".index("a").should_equal(2)
    "blablabla".index("abla").should_equal(2)
    "blablabla".index("ablabla").should_equal(2)
  end  
  
  it.does_not " set $~" do
    $~ = nil
    
    'hello.'.index('ll')
    $~.should_equal(nil)
  end

  it.will "ignore string subclasses" do
    "blablabla".index(StringSpecs::MyString.new("bla")).should_equal(0)
    StringSpecs::MyString.new("blablabla").index("bla").should_equal(0)
    StringSpecs::MyString.new("blablabla").index(StringSpecs::MyString.new("bla")).should_equal(0)
  end
  
  it.will "start the search at the given offset" do
    "blablabla".index("bl", 0).should_equal(0)
    "blablabla".index("bl", 1).should_equal(3)
    "blablabla".index("bl", 2).should_equal(3)
    "blablabla".index("bl", 3).should_equal(3)

    "blablabla".index("bla", 0).should_equal(0)
    "blablabla".index("bla", 1).should_equal(3)
    "blablabla".index("bla", 2).should_equal(3)
    "blablabla".index("bla", 3).should_equal(3)

    "blablabla".index("blab", 0).should_equal(0)
    "blablabla".index("blab", 1).should_equal(3)
    "blablabla".index("blab", 2).should_equal(3)
    "blablabla".index("blab", 3).should_equal(3)

    "blablabla".index("la", 1).should_equal(1)
    "blablabla".index("la", 2).should_equal(4)
    "blablabla".index("la", 3).should_equal(4)
    "blablabla".index("la", 4).should_equal(4)

    "blablabla".index("lab", 1).should_equal(1)
    "blablabla".index("lab", 2).should_equal(4)
    "blablabla".index("lab", 3).should_equal(4)
    "blablabla".index("lab", 4).should_equal(4)

    "blablabla".index("ab", 2).should_equal(2)
    "blablabla".index("ab", 3).should_equal(5)
    "blablabla".index("ab", 4).should_equal(5)
    "blablabla".index("ab", 5).should_equal(5)
    
    "blablabla".index("", 0).should_equal(0)
    "blablabla".index("", 1).should_equal(1)
    "blablabla".index("", 2).should_equal(2)
    "blablabla".index("", 7).should_equal(7)
    "blablabla".index("", 8).should_equal(8)
    "blablabla".index("", 9).should_equal(9)
  end
  
  it.will "start the search at offset + self.length if offset is negative" do
    str = "blablabla"
    
    ["bl", "bla", "blab", "la", "lab", "ab", ""].each do |needle|
      (-str.length .. -1).each do |offset|
        str.index(needle, offset).should ==
        str.index(needle, offset + str.length)
      end
    end
  end

  it.returns "nil if the substring isn't found" do
    "blablabla".index("B").should_equal(nil)
    "blablabla".index("z").should_equal(nil)
    "blablabla".index("BLA").should_equal(nil)
    "blablabla".index("blablablabla").should_equal(nil)
    "blablabla".index("", 10).should_equal(nil)
        
    "hello".index("he", 1).should_equal(nil)
    "hello".index("he", 2).should_equal(nil)
  end
  
  it.can "convert start_offset to an integer via to_int" do
    obj = mock('1')
    obj.should_receive(:to_int).and_return(1)
    "RWOARW".index("RW", obj).should_equal(4)
    
    obj = mock('1')
    obj.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_int).and_return(1)
    "RWOARW".index("RW", obj).should_equal(4)
  end
end

describe "String#index with Regexp" do |it| 
  it.will "behave the same as String#index(string) for escaped string regexps" do
    ["blablabla", "hello cruel world...!"].each do |str|
      ["", "b", "bla", "lab", "o c", "d."].each do |needle|
        regexp = Regexp.new(Regexp.escape(needle))
        str.index(regexp).should_equal(str.index(needle))
        
        0.upto(str.size + 1) do |start|
          str.index(regexp, start).should_equal(str.index(needle, start))
        end
        
        (-str.size - 1).upto(-1) do |start|
          str.index(regexp, start).should_equal(str.index(needle, start))
        end
      end
    end
  end
  
  it.returns "the index of the first match of regexp" do
    "blablabla".index(/bla/).should_equal(0)
    "blablabla".index(/BLA/i).should_equal(0)

    "blablabla".index(/.{0}/).should_equal(0)
    "blablabla".index(/.{6}/).should_equal(0)
    "blablabla".index(/.{9}/).should_equal(0)

    "blablabla".index(/.*/).should_equal(0)
    "blablabla".index(/.+/).should_equal(0)

    "blablabla".index(/lab|b/).should_equal(0)
    
    "blablabla".index(/\A/).should_equal(0)
    "blablabla".index(/\Z/).should_equal(9)
    "blablabla".index(/\z/).should_equal(9)
    "blablabla\n".index(/\Z/).should_equal(9)
    "blablabla\n".index(/\z/).should_equal(10)

    "blablabla".index(/^/).should_equal(0)
    "\nblablabla".index(/^/).should_equal(0)
    "b\nablabla".index(/$/).should_equal(1)
    "bl\nablabla".index(/$/).should_equal(2)
    
    "blablabla".index(/.l./).should_equal(0)
  end

  it.will "set $~ to MatchData of match and nil when there's none" do
    'hello.'.index(/.(.)/)
    $~[0].should_equal('he')

    'hello.'.index(/not/)
    $~.should_equal(nil)
  end
  
  it.will "start the search at the given offset" do
    "blablabla".index(/.{0}/, 5).should_equal(5)
    "blablabla".index(/.{1}/, 5).should_equal(5)
    "blablabla".index(/.{2}/, 5).should_equal(5)
    "blablabla".index(/.{3}/, 5).should_equal(5)
    "blablabla".index(/.{4}/, 5).should_equal(5)

    "blablabla".index(/.{0}/, 3).should_equal(3)
    "blablabla".index(/.{1}/, 3).should_equal(3)
    "blablabla".index(/.{2}/, 3).should_equal(3)
    "blablabla".index(/.{5}/, 3).should_equal(3)
    "blablabla".index(/.{6}/, 3).should_equal(3)

    "blablabla".index(/.l./, 0).should_equal(0)
    "blablabla".index(/.l./, 1).should_equal(3)
    "blablabla".index(/.l./, 2).should_equal(3)
    "blablabla".index(/.l./, 3).should_equal(3)
    
    "xblaxbla".index(/x./, 0).should_equal(0)
    "xblaxbla".index(/x./, 1).should_equal(4)
    "xblaxbla".index(/x./, 2).should_equal(4)
    
    "blablabla\n".index(/\Z/, 9).should_equal(9)
  end
  
  it.will "start the search at offset + self.length if offset is negative" do
    str = "blablabla"
    
    ["bl", "bla", "blab", "la", "lab", "ab", ""].each do |needle|
      (-str.length .. -1).each do |offset|
        str.index(needle, offset).should ==
        str.index(needle, offset + str.length)
      end
    end
  end

  it.returns "nil if the substring isn't found" do
    "blablabla".index(/BLA/).should_equal(nil)

    "blablabla".index(/.{10}/).should_equal(nil)
    "blaxbla".index(/.x/, 3).should_equal(nil)
    "blaxbla".index(/..x/, 2).should_equal(nil)
  end

  it.supports "\\G which matches at the given start offset" do
    "helloYOU.".index(/\GYOU/, 5).should_equal(5)
    "helloYOU.".index(/\GYOU/).should_equal(nil)

    re = /\G.+YOU/
    # The # marks where \G will match.
    [
      ["#hi!YOUall.", 0],
      ["h#i!YOUall.", 1],
      ["hi#!YOUall.", 2],
      ["hi!#YOUall.", nil]
    ].each do |spec|
      
      start = spec[0].index("#")
      str = spec[0].delete("#")
      
      str.index(re, start).should_equal(spec[1])
    end
  end
  
  it.can "convert start_offset to an integer via to_int" do
    obj = mock('1')
    obj.should_receive(:to_int).and_return(1)
    "RWOARW".index(/R./, obj).should_equal(4)

    obj = mock('1')
    obj.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_int).and_return(1)
    "RWOARW".index(/R./, obj).should_equal(4)
  end
end
