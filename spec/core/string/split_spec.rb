# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#split with String" do |it| 
  it.returns "an array of substrings based on splitting on the given string" do
    "mellow yellow".split("ello").should_equal(["m", "w y", "w"])
  end
  
  it.will "suppress trailing empty fields when limit isn't given or 0" do
    "1,2,,3,4,,".split(',').should_equal(["1", "2", "", "3", "4"])
    "1,2,,3,4,,".split(',', 0).should_equal(["1", "2", "", "3", "4"])
    "  a  b  c\nd  ".split("  ").should_equal(["", "a", "b", "c\nd"])
    "hai".split("hai").should_equal([])
    ",".split(",").should_equal([])
    ",".split(",", 0).should_equal([])
  end

  it.returns "an array with one entry if limit is 1: the original string" do
    "hai".split("hai", 1).should_equal(["hai"])
    "x.y.z".split(".", 1).should_equal(["x.y.z"])
    "hello world ".split(" ", 1).should_equal(["hello world "])
    "hi!".split("", 1).should_equal(["hi!"])
  end

  it.returns "at most limit fields when limit > 1" do
    "hai".split("hai", 2).should_equal(["", ""])

    "1,2,,3,4,,".split(',', 2).should_equal(["1", "2,,3,4,,"])
    "1,2,,3,4,,".split(',', 3).should_equal(["1", "2", ",3,4,,"])
    "1,2,,3,4,,".split(',', 4).should_equal(["1", "2", "", "3,4,,"])
    "1,2,,3,4,,".split(',', 5).should_equal(["1", "2", "", "3", "4,,"])
    "1,2,,3,4,,".split(',', 6).should_equal(["1", "2", "", "3", "4", ","])

    "x".split('x', 2).should_equal(["", ""])
    "xx".split('x', 2).should_equal(["", "x"])
    "xx".split('x', 3).should_equal(["", "", ""])
    "xxx".split('x', 2).should_equal(["", "xx"])
    "xxx".split('x', 3).should_equal(["", "", "x"])
    "xxx".split('x', 4).should_equal(["", "", "", ""])
  end
  
  it.does_not " suppress or limit fields when limit is negative" do
    "1,2,,3,4,,".split(',', -1).should_equal(["1", "2", "", "3", "4", "", ""])
    "1,2,,3,4,,".split(',', -5).should_equal(["1", "2", "", "3", "4", "", ""])
    "  a  b  c\nd  ".split("  ", -1).should_equal(["", "a", "b", "c\nd", ""])
    ",".split(",", -1).should_equal(["", ""])
  end
  
  it.will "default to $; when string isn't given or nil" do
    begin
      old_fs = $;
    
      [",", ":", "", "XY", nil].each do |fs|
        $; = fs
        
        ["x,y,z,,,", "1:2:", "aXYbXYcXY", ""].each do |str|
          expected = str.split(fs || " ")
          
          str.split(nil).should_equal(expected)
          str.split.should_equal(expected)

          str.split(nil, -1).should_equal(str.split(fs || " ", -1))
          str.split(nil, 0).should_equal(str.split(fs || " ", 0))
          str.split(nil, 2).should_equal(str.split(fs || " ", 2))
        end
      end
    ensure
      $; = old_fs
    end    
  end
    
  it.will "ignore leading and continuous whitespace when string is a single space" do
    " now's  the time  ".split(' ').should_equal(["now's", "the", "time"])
    " now's  the time  ".split(' ', -1).should_equal(["now's", "the", "time", ""])

    "\t\n a\t\tb \n\r\r\nc\v\vd\v ".split(' ').should_equal(["a", "b", "c", "d"])
    "a\x00a b".split(' ').should_equal(["a\x00a", "b"])
  end
  
  it.will "split between characters when its argument is an empty string" do
    "hi!".split("").should_equal(["h", "i", "!"])
    "hi!".split("", -1).should_equal(["h", "i", "!", ""])
    "hi!".split("", 2).should_equal(["h", "i!"])
  end
  
  it.tries "converting its pattern argument to a string via to_str" do
    obj = mock('::')
    def obj.to_str() "::" end
    "hello::world".split(obj).should_equal(["hello", "world"])

    obj = mock('::')
    obj.should_receive(:respond_to?).with(:to_str).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_str).and_return("::")
    "hello::world".split(obj).should_equal(["hello", "world"])
  end
  
  it.tries "converting limit to an integer via to_int" do
    obj = mock('2')
    def obj.to_int() 2 end
    "1.2.3.4".split(".", obj).should_equal(["1", "2.3.4"])

    obj = mock('2')
    obj.should_receive(:respond_to?).with(:to_int).and_return(true)
    obj.should_receive(:method_missing).with(:to_int).and_return(2)
    "1.2.3.4".split(".", obj).should_equal(["1", "2.3.4"])
  end
  
  it.does_not " set $~" do
    $~ = nil
    "x.y.z".split(".")
    $~.should_equal(nil)
  end
  
  it.returns "subclass instances based on self" do
    ["", "x.y.z.", "  x  y  "].each do |str|
      ["", ".", " "].each do |pat|
        [-1, 0, 1, 2].each do |limit|
          StringSpecs::MyString.new(str).split(pat, limit).each do |x|
            x.class.should_equal(StringSpecs::MyString)
          end
          
          str.split(StringSpecs::MyString.new(pat), limit).each do |x|
            x.class.should_equal(String )
          end
        end
      end
    end
  end
  
  it.does_not "call constructor on created subclass instances" do
    # can't call should_not_receive on an object that doesn't yet exist
    # so failure here is signalled by exception, not expectation failure
    
    s = StringSpecs::StringWithRaisingConstructor.new('silly:string')
    s.split(':').first.should_equal('silly')
  end
    
  it.will "taint the resulting strings if self is tainted" do
    ["", "x.y.z.", "  x  y  "].each do |str|
      ["", ".", " "].each do |pat|
        [-1, 0, 1, 2].each do |limit|
          str.dup.taint.split(pat).each do |x|
            x.tainted?.should_equal(true)
          end
          
          str.split(pat.dup.taint).each do |x|
            x.tainted?.should_equal(false)
          end
        end
      end
    end    
  end
end

describe "String#split with Regexp" do |it| 
  it.can "divides self on regexp matches" do
    " now's  the time".split(/ /).should_equal(["", "now's", "", "the", "time"])
    " x\ny ".split(/ /).should_equal(["", "x\ny"])
    "1, 2.34,56, 7".split(/,\s*/).should_equal(["1", "2.34", "56", "7"])
    "1x2X3".split(/x/i).should_equal(["1", "2", "3"])
  end

  it.will "treat negative limits as no limit" do
    "".split(%r!/+!, -1).should_equal([])
  end
  
  it.will "suppress trailing empty fields when limit isn't given or 0" do
    "1,2,,3,4,,".split(/,/).should_equal(["1", "2", "", "3", "4"])
    "1,2,,3,4,,".split(/,/, 0).should_equal(["1", "2", "", "3", "4"])
    "  a  b  c\nd  ".split(/\s+/).should_equal(["", "a", "b", "c", "d"])
    "hai".split(/hai/).should_equal([])
    ",".split(/,/).should_equal([])
    ",".split(/,/, 0).should_equal([])
  end

  it.returns "an array with one entry if limit is 1: the original string" do
    "hai".split(/hai/, 1).should_equal(["hai"])
    "xAyBzC".split(/[A-Z]/, 1).should_equal(["xAyBzC"])
    "hello world ".split(/\s+/, 1).should_equal(["hello world "])
    "hi!".split(//, 1).should_equal(["hi!"])
  end

  it.returns "at most limit fields when limit > 1" do
    "hai".split(/hai/, 2).should_equal(["", ""])

    "1,2,,3,4,,".split(/,/, 2).should_equal(["1", "2,,3,4,,"])
    "1,2,,3,4,,".split(/,/, 3).should_equal(["1", "2", ",3,4,,"])
    "1,2,,3,4,,".split(/,/, 4).should_equal(["1", "2", "", "3,4,,"])
    "1,2,,3,4,,".split(/,/, 5).should_equal(["1", "2", "", "3", "4,,"])
    "1,2,,3,4,,".split(/,/, 6).should_equal(["1", "2", "", "3", "4", ","])

    "x".split(/x/, 2).should_equal(["", ""])
    "xx".split(/x/, 2).should_equal(["", "x"])
    "xx".split(/x/, 3).should_equal(["", "", ""])
    "xxx".split(/x/, 2).should_equal(["", "xx"])
    "xxx".split(/x/, 3).should_equal(["", "", "x"])
    "xxx".split(/x/, 4).should_equal(["", "", "", ""])
  end
  
  it.does_not " suppress or limit fields when limit is negative" do
    "1,2,,3,4,,".split(/,/, -1).should_equal(["1", "2", "", "3", "4", "", ""])
    "1,2,,3,4,,".split(/,/, -5).should_equal(["1", "2", "", "3", "4", "", ""])
    "  a  b  c\nd  ".split(/\s+/, -1).should_equal(["", "a", "b", "c", "d", ""])
    ",".split(/,/, -1).should_equal(["", ""])
  end
  
  it.will "default to $; when regexp isn't given or nil" do
    begin
      old_fs = $;
    
      [/,/, /:/, //, /XY/, /./].each do |fs|
        $; = fs
        
        ["x,y,z,,,", "1:2:", "aXYbXYcXY", ""].each do |str|
          expected = str.split(fs)
          
          str.split(nil).should_equal(expected)
          str.split.should_equal(expected)

          str.split(nil, -1).should_equal(str.split(fs, -1))
          str.split(nil, 0).should_equal(str.split(fs, 0))
          str.split(nil, 2).should_equal(str.split(fs, 2))
        end
      end
    ensure
      $; = old_fs
    end    
  end
  
  it.will "split between characters when regexp matches a zero-length string" do
    "hello".split(//).should_equal(["h", "e", "l", "l", "o"])
    "hello".split(//, -1).should_equal(["h", "e", "l", "l", "o", ""])
    "hello".split(//, 2).should_equal(["h", "ello"])
    
    "hi mom".split(/\s*/).should_equal(["h", "i", "m", "o", "m"])
  end
  
  it.will "include all captures in the result array" do
    "hello".split(/(el)/).should_equal(["h", "el", "lo"])
    "hi!".split(/()/).should_equal(["h", "", "i", "", "!"])
    "hi!".split(/()/, -1).should_equal(["h", "", "i", "", "!", "", ""])
    "hello".split(/((el))()/).should_equal(["h", "el", "el", "", "lo"])
    "AabB".split(/([a-z])+/).should_equal(["A", "b", "B"])
  end

  it.does_not "include non-matching captures in the result array" do
    "hello".split(/(el)|(xx)/).should_equal(["h", "el", "lo"])
  end

  it.tries "converting limit to an integer via to_int" do
    obj = mock('2')
    def obj.to_int() 2 end
    "1.2.3.4".split(".", obj).should_equal(["1", "2.3.4"])

    obj = mock('2')
    obj.should_receive(:respond_to?).with(:to_int).and_return(true)
    obj.should_receive(:method_missing).with(:to_int).and_return(2)
    "1.2.3.4".split(".", obj).should_equal(["1", "2.3.4"])
  end
  
  it.does_not " set $~" do
    $~ = nil
    "x:y:z".split(/:/)
    $~.should_equal(nil)
  end
  
  it.returns "the original string if no matches are found" do
    "foo".split("\n").should_equal(["foo"])
  end
  
  it.returns "subclass instances based on self" do
    ["", "x:y:z:", "  x  y  "].each do |str|
      [//, /:/, /\s+/].each do |pat|
        [-1, 0, 1, 2].each do |limit|
          StringSpecs::MyString.new(str).split(pat, limit).each do |x|
            x.class.should_equal(StringSpecs::MyString)
          end
        end
      end
    end
  end

  it.does_not "call constructor on created subclass instances" do
    # can't call should_not_receive on an object that doesn't yet exist
    # so failure here is signalled by exception, not expectation failure
    
    s = StringSpecs::StringWithRaisingConstructor.new('silly:string')
    s.split(/:/).first.should_equal('silly')
  end
  
  it.will "taint the resulting strings if self is tainted" do
    ["", "x:y:z:", "  x  y  "].each do |str|
      [//, /:/, /\s+/].each do |pat|
        [-1, 0, 1, 2].each do |limit|
          str.dup.taint.split(pat).each do |x|
            x.tainted?.should_equal(true)
          end
          
          str.split(pat.dup.taint).each do |x|
            x.tainted?.should_equal(false)
          end
        end
      end
    end    
  end  
end
