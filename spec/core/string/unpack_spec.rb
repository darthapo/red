# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

if ENV['MRI'] then
  $: << 'kernel/core'
  require 'unpack'
end

# FIXME: "according to the format string" is NOT a spec description!

describe "String#unpack" do |it| 
  it.returns "an array by decoding self according to the format string" do
    "abc \0\0abc \0\0".unpack('A6Z6').should_equal(["abc", "abc "])
    "abc \0\0".unpack('a3a3').should_equal(["abc", " \000\000"])
    "aa".unpack('b8B8').should_equal(["10000110", "01100001"])
    "aaa".unpack('h2H2c').should_equal(["16", "61", 97])
    "now=20is".unpack('M*').should_equal(["now is"])
    "whole".unpack('xax2aX2aX1aX2a').should_equal(["h", "e", "l", "l", "o"])
  end
end

describe "String#unpack with nil format argument" do |it| 
  it.raises " a TypeError exception" do
    lambda { "abc".unpack(nil) }.should_raise(TypeError)
  end
end

describe "String#unpack with 'Z' directive" do |it| 
  it.returns "an array by decoding self according to the format string" do
    "abc \0abc \0".unpack('Z*Z*').should_equal(["abc ", "abc "])
    "abc \0abc \0".unpack('Z10').should_equal(["abc "])
    "abc \0abc \0".unpack('Z7Z*').should_equal(["abc ", "c "])
    "abc \0abc \0".unpack('Z50Z*').should_equal(["abc ", ""])
    "abc \0\0\0abc \0".unpack('Z*Z*').should_equal(["abc ", ""])
    "abc \0\0\0\0".unpack('Z*').should_equal(["abc "])
    "abc \0\0\0\0".unpack('Z*Z*').should_equal(["abc ", ""])
    "\0".unpack('Z*').should_equal([""])
    "\0\0".unpack('Z*').should_equal([""])
    "\0\0abc".unpack('Z*').should_equal([""])
    "\0\0abc\0\0".unpack('Z*').should_equal([""])
    "\0 abc\0\0abc\0abc \0\0 ".unpack('Z2Z*Z3ZZ*Z10Z10').should_equal(["", "abc", "", "c", "", "abc ", ""])
  end
end

describe "String#unpack with 'N' and 'n' directives" do |it| 
  it.returns "an array by decoding self according to the format string" do
    "\xF3\x02\x00\x42".unpack('N').should_equal([4076994626])
    "\xF3\x02".unpack('N').should_equal([nil])
    "\xF3\x02\x00\x42\x32\x87\xF3\x00".unpack('N2').should_equal([4076994626, 847770368])
    "\xF3\x02\xC0\x42\x3A\x87\xF3\x00".unpack('N*').should_equal([4077043778, 981988096])
    "\xF3\x02\x00\x42".unpack('n').should_equal([62210])
    "\x01\x62\xEE\x42".unpack('n-7n').should_equal([354, 60994])
    "\xF3\x02\x00\x42".unpack('n5').should_equal([62210, 66, nil, nil, nil])
    "\xF3".unpack('n').should_equal([nil])
    "\xF3\x02\x00\x42\x32\x87\xF3\x00".unpack('n3').should_equal([62210, 66, 12935])
    "\xF3\x02\x00\x42\x32\x87\xF3\x00".unpack('n*').should_equal([62210, 66, 12935, 62208])
    "\xF3\x02\x00\x42\x32\x87\xF3\x02".unpack('n0N*').should_equal([4076994626, 847770370])
  end
end

describe "String#unpack with 'V' and 'v' directives" do |it| 
  it.returns "an array by decoding self according to the format string" do
    "\xF3\x02\x00\x42".unpack('V').should_equal([1107297011])
    "\xF3\x02".unpack('V').should_equal([nil])
    "\xF3\xFF\xFF\xFF\x32\x0B\x02\x00".unpack('V2').should_equal([4294967283, 133938])
    "\xF3\x02\xC0\x42\x3A\x87\xF3\x00".unpack('V*').should_equal([1119879923, 15959866])
    "\xF3\x02\x00\x42".unpack('v').should_equal([755])
    "\x01\x62\xEE\x42".unpack('v-7v').should_equal([25089, 17134])
    "\xF3\x02\x00\x42".unpack('v5').should_equal([755, 16896, nil, nil, nil])
    "\xF3".unpack('v').should_equal([nil])
    "\xF3\xFF\xFF\xFF\x32\x87\xF3\x00".unpack('v3').should_equal([65523, 65535, 34610])
    "\xF3\x02\x00\x42\x32\x87\xF3\x00".unpack('v*').should_equal([755, 16896, 34610, 243])
    "\xF3\x02\x00\x42\x32\x87\xF3\x02".unpack('v0V*').should_equal([1107297011, 49514290])
  end
end

describe "String#unpack with 'C' and 'c' directives" do |it| 
  it.returns "an array by decoding self according to the format string" do
    "\xF3\x02\x00\x42".unpack('C').should_equal([243])
    "".unpack('C').should_equal([nil])
    "\xF3\x02\x00\x42\x32\x87\xF3\x00".unpack('C2').should_equal([243, 2])
    "\xF3\x02\xC0\x42\x3A\x87\xF3\x00".unpack('C*').should_equal([243, 2, 192, 66, 58, 135, 243, 0])
    "\xF3\x02\x00\x42".unpack('c').should_equal([-13])
    "\x01\x62\xEE\x42".unpack('c-7c').should_equal([1, 98])
    "\xF3\x02\x00\x42".unpack('c5').should_equal([-13, 2, 0, 66, nil])
    "\x80".unpack('c').should_equal([-128])
    "\x7F\x02\x00\x42\x32\x87\xF3\x00".unpack('c3').should_equal([127, 2, 0])
    "\x80\x02\x00\x42\xFF\x87\xF3\x00".unpack('c*').should_equal([-128, 2, 0, 66, -1, -121, -13, 0])
    "\xF3\x02\x00\x42\x32\x87\xF3\x02".unpack('c0C*').should_equal([243, 2, 0, 66, 50, 135, 243, 2])
  end
end

describe "String#unpack with 'Q' and 'q' directives" do |it| 
  it.returns "Fixnums for small numeric values" do
    "\x00\x00\x00\x00\x00\x00\x00\x00".unpack('Q').should_equal([0])
    "\x00\x00\x00\x00\x00\x00\x00\x00".unpack('q').should_equal([0])
    "\x00\x00\x00\x00\x00\x00\x00\x00".unpack('Q')[0].class.should_equal(Fixnum)
    "\x00\x00\x00\x00\x00\x00\x00\x00".unpack('q')[0].class.should_equal(Fixnum)
  end
end

describe "String#unpack with 'a', 'X' and 'x' directives" do |it| 
  it.returns "an array by decoding self according to the format string" do
    "abc".unpack('x3a').should_equal([""])
    "abc".unpack('x3X3x0a').should_equal(["a"])
    "abc".unpack('x2X-5a').should_equal(["b"])
    "abcdefghijklmnopqrstuvwxyz".unpack('aaax10aX14X0a').should_equal(["a", "b", "c", "n", "a"])
    "abcdefghijklmnopqrstuvwxyz".unpack('aa-8ax10aX*a').should_equal(["a", "b", "c", "n", "c"])
    "abcdefghijklmnopqrstuvwxyz".unpack('x*aX26a').should_equal(["", "a"])
    "abcdefghijklmnopqrstuvwxyz".unpack('x*x*x*aX26a').should_equal(["", "a"])
    "abc".unpack('x3X*').should_equal([])
    "abc".unpack('x3X*a').should_equal([""])
    "abc".unpack('x3X*X3a').should_equal(["a"])
    lambda { "abc".unpack('X*') }.should_raise(ArgumentError)
    lambda { "abc".unpack('x*x') }.should_raise(ArgumentError)
    lambda { "abc".unpack('x4') }.should_raise(ArgumentError)
    lambda { "abc".unpack('X') }.should_raise(ArgumentError)
    lambda { "abc".unpack('xX*') }.should_raise(ArgumentError)
  end
end

describe "String#unpack with 'DdEeFfGg' directives" do |it| 
  before :each do
    @precision_small = 1E-12
    @precision_large = 1E+17
  end
  
  it.returns "an array by decoding self according to the format string" do
    res = "\xF3\x02\x00\x42\xF3\x02\x00\x42".unpack('eg')
    res.length.should_equal(2)
    res[0].should_be_close(32.0028800964355, @precision_small)
    res[1].should_be_close(-1.02997409159585e+31, @precision_large)

    res = "\xF3\x02\x00\x42\xF3\x02\x00\x42".unpack('eg')
    res.length.should_equal(2)
    res[0].should_be_close(32.0028800964355, @precision_small)
    res[1].should_be_close(-1.02997409159585e+31, @precision_large)

    "\xF3\x02".unpack('GD').should_equal([nil, nil])

#     "\xF3\x02\x00\x42\x32\x87\xF3\x00".unpack('E*')[0].should_be_close(
#         4.44943241769783e-304, @precision_small)
#     "\x00\x00\x00\x42\x32\x87\xF3\x02".unpack('g0G*')[0].should_be_close(
#         1.40470576419087e-312, @precision_small)
  end
end

describe "String#unpack with 'B' and 'b' directives" do |it| 
  it.returns "an array by decoding self according to the format string" do
    "\xFF\x00\x80\x01\x7E\xAA\xF0\x0F".unpack('B64').should ==
      ["1111111100000000100000000000000101111110101010101111000000001111"]
    "\xFF\x00\x80\x01\x7E\xAA\xF0\x0F".unpack('b64').should ==
      ["1111111100000000000000011000000001111110010101010000111111110000"]
    "\xFF\x00\x80\x01\x7E\xAA\xF0\x0F".unpack('B12b12B12b12B*b*').should ==
      ["111111110000", "000000011000", "011111101010", "000011111111", "", ""]
    "\xFF\x00\x80\x01\x7E\xAA\xF0\x0F".unpack('B4b4B4b4B4b4B16').should ==
      ["1111", "0000", "1000", "1000", "0111", "0101", "1111000000001111"]
    "\xFF\x00\x80\xAA".unpack('b-5B8b8b0B2b1B1').should ==
      ["1", "00000000", "00000001", "", "10", "", ""]
    "\xFF\x00\x80\xAA".unpack('B0b0').should_equal(["", ""])
    "\xFF\x00\x80\xAA".unpack('B3b*B*').should_equal(["111", "000000000000000101010101", ""])
    "\xFF\x00\x80\xAA".unpack('B3B*b*').should_equal(["111", "000000001000000010101010", ""])
  end
end

describe "String#unpack with 'H' and 'h' directives" do |it| 
  it.returns "an array by decoding self according to the format string" do
    "\xFF\x00\x80\x01\x7E\xAA\xF0\x0F".unpack('H16').should_equal(["ff0080017eaaf00f"])
    "\xFF\x00\x80\x01\x7E\xAA\xF0\x0F".unpack('h16').should_equal(["ff000810e7aa0ff0"])
    "\xFF\x00\x80\x01\x7E\xAA\xF0\x0F".unpack('H3h3H3h3H*h*').should ==
      ["ff0", "081", "7ea", "0ff", "", ""]
    "\xFF\x00\x80\x01\x7E\xAA\xF0\x0F".unpack('HhHhHhH4').should ==
      ["f", "0", "8", "1", "7", "a", "f00f"]
    "\xFF\x00\x80\xAA".unpack('h-5H2h2h0Hh1H1').should ==
      ["f", "00", "08", "", "a", "", ""]
    "\xFF\x00\x80\xAA".unpack('H0h0').should_equal(["", ""])
    "\xFF\x00\x80\xAA".unpack('H3h*H*').should_equal(["ff0", "08aa", ""])
    "\xFF\x00\x80\xAA".unpack('H3H*h*').should_equal(["ff0", "80aa", ""])
  end
end

describe "String#unpack with 'U' directive" do |it| 
  it.returns "an array by decoding self according to the format string" do
    "\xFD\x80\x80\xB7\x80\x80".unpack('U').should_equal([1073967104])
    "\xF9\x80\x80\x80\x80".unpack('U').should_equal([16777216])
    "\xF1\x80\x80\x80".unpack('UU').should_equal([262144])
    "\xE1\xB7\x80".unpack('U').should_equal([7616])
    "\xC2\x80\xD2\x80".unpack('U-8U').should_equal([128, 1152])
    "\x00\x7F".unpack('U100').should_equal([0, 127])
    "\x05\x7D".unpack('U0U0').should_equal([])
    "".unpack('U').should_equal([])
    "\xF1\x80\x80\xB1\xE1\x8A\x80\xC2\xBF\x0C\x6B".unpack('U*').should_equal([262193, 4736, 191, 12, 107])
    "\xF1\x8F\x85\xB1\xE1\x8A\x89\xC2\xBF\x0C\x6B".unpack('U2x2U').should_equal([323953, 4745, 12])
    lambda { "\xF0\x80\x80\x80".unpack('U') }.should_raise(ArgumentError)
    lambda { "\xE0\x80\x80".unpack('U') }.should_raise(ArgumentError)
    lambda { "\xC0\x80".unpack('U') }.should_raise(ArgumentError)
    lambda { "\xC1\x80".unpack('U') }.should_raise(ArgumentError)
    lambda { "\x80".unpack('U') }.should_raise(ArgumentError)
    lambda { "\xF1\x80\x80".unpack('U') }.should_raise(ArgumentError)
    lambda { "\xE1\x80".unpack('U') }.should_raise(ArgumentError)
    lambda { "\xC2".unpack('U') }.should_raise(ArgumentError)
    lambda { "\xF1\x00\x00\x00".unpack('U') }.should_raise(ArgumentError)
    lambda { "\xE1\x00\x00".unpack('U') }.should_raise(ArgumentError)
    lambda { "\xC2\x00".unpack('U') }.should_raise(ArgumentError)
    lambda { "\xFE".unpack('U') }.should_raise(ArgumentError)
    lambda { "\x03\xFF".unpack('UU') }.should_raise(ArgumentError)
  end
end

describe "String#unpack with 'A' directive" do |it| 
  it.returns "an array by decoding self according to the format string" do
    "".unpack('A').should_equal([""])
    " \0 abc \0\0\0abc\0\0 \0abc".unpack('A*').should ==
      [" \000 abc \000\000\000abc\000\000 \000abc"]
    " \0 abc \0\0\0abc\0\0 \0abc \0 a ".unpack('A16A-9A*A*A100').should ==
      [" \000 abc \000\000\000abc", "", "abc \000 a", "", ""]
    " \0 abc \0\0\0abc\0\0 \0abc \0 a ".unpack('A3A4AAA').should_equal(["", "abc", "", "", ""])
    " \0 abc \0\0\0abc\0\0 \0abc \0 a ".unpack('A2A0A14').should_equal(["", "", " abc \000\000\000abc"])
  end
end

describe "String#unpack with '@' directive" do |it| 
  it.returns "an array by decoding self according to the format string" do
    "abcdefg".unpack('@2').should     == []
    "abcdefg".unpack('@3@-5a').should_equal(["a"])
    "abcdefg".unpack('@*@a').should   == ["a"]
    "abcdefg".unpack('@3@5a').should  == ["f"]
    "abcdefg".unpack('@*a').should    == [""]
    "abcdefg".unpack('@7a').should    == [""]
    lambda { "abcdefg".unpack('@8') }.should_raise(ArgumentError)
  end
end

describe "String#unpack with 'M' directive" do |it| 
  it.returns "an array by decoding self according to the format string" do
    "".unpack('M').should_equal([""])
    "=5".unpack('Ma').should_equal(["", ""])
    "abc=".unpack('M').should_equal(["abc"])
    "a=*".unpack('MMMM').should_equal(["a", "*", "", ""])

    "\x3D72=65abcdefg=5%=33".unpack('M').should    == ["reabcdefg"]
    "\x3D72=65abcdefg=5%=33".unpack('M0').should   == ["reabcdefg"]
    "\x3D72=65abcdefg=5%=33".unpack('M100').should_equal(["reabcdefg"])
    "\x3D72=65abcdefg=5%=33".unpack('M*').should   == ["reabcdefg"]
    "\x3D72=65abcdefg=5%=33".unpack('M-8M').should_equal(["reabcdefg", "%3"])

    "abc===abc".unpack('MMMMM').should_equal(["abc", "", "\253c", "", ""])
    "=$$=47".unpack('MMMM').should_equal(["", "$$G", "", ""])
    "=$$=4@=47".unpack('MMMMM').should_equal(["", "$$", "@G", "", ""])
    "=$$=4@=47".unpack('M5000').should_equal([""])
    "=4@".unpack('MMM').should_equal(["", "@", ""])
  end
end

describe "String#unpack with 'm' directive" do |it| 
  it.returns "an array by decoding self according to the format string" do
    "YQ==".unpack('m').should_equal(["a"])
    "YWE=".unpack('m').should_equal(["aa"])
    "ab c=awerB2y+".unpack('mmmmm').should_equal(["i\267", "k\a\253\al\276", "", "", ""])
    "a=b=c=d=e=f=g=".unpack('mamamamam').should ==
      ["i", "=", "q", "=", "y", "=", "", "", ""]
    "a===b===c===d===e===f===g===".unpack('mamamamam').should ==
      ["i", "=", "q", "=", "y", "=", "", "", ""]
    "ab c= de f= gh i= jk l=".unpack('mmmmmmmmmm').should ==
      ["i\267", "u\347", "\202\030", "\216I", "", "", "", "", "", ""]
    "+/=\n".unpack('mam').should           == ["\373", "=", ""]
    "aA==aA==aA==".unpack('m-100').should  == ["h"]
    "aGk=aGk=aGk=".unpack('m*mm').should   == ["hi", "hi", "hi"]
    "aA".unpack('m55').should              == [""]
    "aGk".unpack('m').should               == [""]
    "/w==".unpack('m').should              == ["\377"]
    "Pj4+".unpack('m').should              == [">>>"]
    "<>:?Pj@$%^&*4+".unpack('m').should    == [">>>"]
    "<>:?Pja@$%^&*4+".unpack('ma').should  == [">6\270", ""]
    "<>:?P@$%^&*+".unpack('ma').should     == ["", ""]
    "54321".unpack('m').should             == ["\347\215\366"]
    "==43".unpack('m').should              == [""]
    "43aw".unpack('mmm').should            == ["\343v\260", "", ""]
    "=======43aw".unpack('m').should       == ["\343v\260"]
    "cmVxdWlyZSAnYmFzZTY0Jw==".unpack('m').should_equal(["require 'base64'"])
    "+/=".unpack('m').should_equal(["\373"])
    "YXNkb2Zpc09BSVNERk9BU0lESjk4ODc5ODI0YWlzdWYvLy8rKw==".unpack('m').should ==
      ["asdofisOAISDFOASIDJ98879824aisuf///++"]
    "IUAjJSMgJCBeJV4qJV4oXiYqKV8qKF8oKStQe308Pj9LTCJLTCI6\n".unpack('m').should ==
      ["!@#$@#%# $ ^%^*%^(^&*)_*(_()+P{}<>?KL\"KL\":"]
    "sfj98349//+ASDd98934jg+N,CBMZP2133GgHJiYrB12".unpack('m').should ==
      ["\261\370\375\363~=\377\377\200H7}\363\335\370\216\017\215\b\023\031?mw\334h\a&&+"]
  end
end
