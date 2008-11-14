# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

if ENV['MRI'] then
  $: << 'kernel/core'
  require 'pack'
end

describe "Array#pack" do |it| 
  it.raises " an ArgumentError with ('%')" do
    lambda { [].pack("%") }.should_raise(ArgumentError)
  end

  it.raises " an ArgumentError on empty array" do
    ['A', 'a', 'B', 'b', 'C', 'c', 'D', 'd',
     'E', 'e', 'F', 'f', 'G', 'g', 'H', 'h',
     'I', 'i', 'L', 'l', 'M', 'm', 'N', 'n',
     'Q', 'q', 'U', 'u','w', 'Z'].each { |pat|
       lambda { [].pack(pat) }.should_raise(ArgumentError)
     }
  end

  it.can "skips everything till the end of schema string with ('#')" do
    ["abc", "def"].pack("A*#A10%").should_equal("abc")
  end

  it.can "skips everything till the end of schema line with ('#')" do
    ["abc", "def"].pack("A*#A10%\nA*").should_equal("abcdef")
  end

  it.returns "space padded string with ('A<count>')" do
    ['abcde'].pack('A7').should_equal('abcde  ')
  end

  it.can "cuts string if its size greater than directive count with ('A<count>')" do
    ['abcde'].pack('A3').should_equal('abc')
  end

  it.can "consider count = 1 if count omited with ('A')" do
    ['abcde'].pack('A').should_equal('a')
  end

  it.returns "empty string if count = 0 with ('A<count>')" do
    ['abcde'].pack('A0').should_equal('')
  end

  it.returns "the whole argument string with star parameter with ('A')" do
    ['abcdef'].pack('A*').should_equal('abcdef')
  end

  it.raises " a TypeError if array item is not String with ('A<count>')" do
    lambda { [123].pack('A5') }.should_raise(TypeError)
    lambda { [:hello].pack('A5') }.should_raise(TypeError)
    lambda { [mock('not string')].pack('A5') }.should_raise(TypeError)
  end

  it.returns "null padded string with ('a<count>')" do
    ['abcdef'].pack('a7').should_equal("abcdef\x0")
  end

  it.can "cuts string if its size greater than directive count with ('a<count>')" do
    ['abcde'].pack('a3').should_equal('abc')
  end

  it.can "considers count = 1 if count omited with ('a')" do
    ['abcde'].pack('a').should_equal('a')
  end

  it.returns "empty string if count = 0 with ('a<count>')" do
    ['abcde'].pack('a0').should_equal('')
  end

  it.returns "the whole argument string with star parameter with ('a')" do
    ['abcdef'].pack('a*').should_equal('abcdef')
  end

  it.raises " a TypeError if array item is not String with ('a<count>')" do
    lambda { [123].pack('a5') }.should_raise(TypeError)
    lambda { [:hello].pack('a5') }.should_raise(TypeError)
    lambda { [mock('not string')].pack('a5') }.should_raise(TypeError)
  end

  it.returns "packed bit-string descending order with ('B')" do
    ["011000010110001001100011"].pack('B24').should_equal('abc')
  end

  it.can "uses char codes to determine if bit is set or not with ('B')" do
    ["bccddddefgghhhijjkklllmm"].pack('B24').should_equal(["011000010110001001100011"].pack('B24'))
  end

  it.can "conversion edge case: all zeros with ('B')" do
    ["00000000"].pack('B8').should_equal("\000")
  end

  it.can "conversion edge case: all ones with ('B')" do
    ["11111111"].pack('B8').should_equal("\377")
  end

  it.can "conversion edge case: left one with ('B')" do
    ["10000000"].pack('B8').should_equal("\200")
  end

  it.can "conversion edge case: right one with ('B')" do
    ["00000001"].pack('B8').should_equal("\001")
  end

  it.can "conversion edge case: edge sequences not in first char with ('B')" do
    ["0000000010000000000000011111111100000000"].pack('B40').should_equal("\000\200\001\377\000")
  end

  it.can "uses zeros if count is not multiple of 8 with ('B')" do
    ["00111111"].pack('B4').should_equal(["00110000"].pack('B8'))
  end

  it.returns "zero-char for each 2 of count that greater than string length with ('B')" do
    [""].pack('B6').should_equal("\000\000\000")
  end

  it.returns "extra zero char if count is odd and greater than string length with ('B')" do
    [""].pack('B7').should_equal("\000\000\000\000")
  end

  it.will "start new char if string is ended before char's 8 bits with ('B')" do
    ["0011"].pack('B8').should_equal("0\000\000")
  end

  it.can "considers count = 1 if no explicit count it given with ('B')" do
    ["10000000"].pack('B').should_equal(["10000000"].pack('B1'))
    ["01000000"].pack('B').should_equal(["01000000"].pack('B1'))
  end

  it.returns "empty string if count = 0 with ('B')" do
    ["10101010"].pack('B0').should_equal("")
  end

  it.can "uses argument string length as count if count = * with ('B')" do
    ["00111111010"].pack('B*').should_equal(["00111111010"].pack('B11'))
  end

  it.can "consumes only one array item with ('B')" do
    ["0011", "1111"].pack('B*').should_equal(["0011"].pack('B4'))
    ["0011", "1011"].pack('B*B*').should_equal(["0011"].pack('B4') + ["1011"].pack('B4'))
  end

  it.raises " a TypeError if corresponding array item is not String with ('B')" do
    lambda { [123].pack('B8') }.should_raise(TypeError)
    lambda { [:data].pack('B8') }.should_raise(TypeError)
    lambda { [mock('not string')].pack('B8') }.should_raise(TypeError)
  end

  it.returns "packed bit-string descending order with ('b')" do
    ["100001100100011011000110"].pack('b24').should_equal('abc')
  end

  it.can "conversion edge case: all zeros with ('b')" do
    ["00000000"].pack('b8').should_equal("\000")
  end

  it.can "conversion edge case: all ones with ('b')" do
    ["11111111"].pack('b8').should_equal("\377")
  end

  it.can "conversion edge case: left one with ('b')" do
    ["10000000"].pack('b8').should_equal("\001")
  end

  it.can "conversion edge case: right one with ('b')" do
    ["00000001"].pack('b8').should_equal("\200")
  end

  it.can "conversion edge case: edge sequences not in first char with ('b')" do
    ["0000000010000000000000011111111100000000"].pack('b40').should_equal("\000\001\200\377\000")
  end

  it.can "uses char codes to determine if bit is set or not with ('b')" do
    ["abbbbccddefffgghiijjjkkl"].pack('b24').should_equal(["100001100100011011000110"].pack('b24'))
  end

  it.can "uses zeros if count is not multiple of 8 with ('b')" do
    ["00111111"].pack('b4').should_equal(["00110000"].pack('b8'))
  end

  it.returns "zero-char for each 2 of count that greater than string length with ('b')" do
    [""].pack('b6').should_equal("\000\000\000")
  end

  it.returns "extra zero char if count is odd and greater than string length with ('b')" do
    [""].pack('b7').should_equal("\000\000\000\000")
  end

  it.will "start new char if argument string is ended before char's 8 bits with ('b')" do
    ["0011"].pack('b8').should_equal("\f\000\000")
  end

  it.can "considers count = 1 if no explicit count it given with ('b')" do
    ["10000000"].pack('b').should_equal(["10000000"].pack('b1'))
    ["01000000"].pack('b').should_equal(["01000000"].pack('b1'))
  end

  it.returns "empty string if count = 0 with ('b')" do
    ["10101010"].pack('b0').should_equal("")
  end

  it.can "uses argument string length as count if count = * with ('b')" do
    ["00111111010"].pack('b*').should_equal(["00111111010"].pack('b11'))
  end

  it.can "consumes only one array item with ('b')" do
    ["0011", "1111"].pack('b*').should_equal(["0011"].pack('b4'))
    ["0011", "1011"].pack('b*b*').should_equal(["0011"].pack('b4') + ["1011"].pack('b4'))
  end

  it.raises " a TypeError if corresponding array item is not String with ('b')" do
    lambda { [123].pack('b8') }.should_raise(TypeError)
    lambda { [:data].pack('b8') }.should_raise(TypeError)
    lambda { [mock('not string')].pack('b8') }.should_raise(TypeError)
  end

  it.returns "string with char of appropriate number with ('C')" do
    [49].pack('C').should_equal('1')
  end

  it.can "reduces value to fit in byte with ('C')" do
    [257].pack('C').should_equal("\001")
  end

  it.can "convert negative values to positive with ('C')" do
    [-1].pack('C').should_equal([255].pack('C'))
    [-257].pack('C').should_equal([255].pack('C'))
  end

  it.can "convert float to integer and returns char with that number with ('C')" do
    [5.0].pack('C').should_equal([5].pack('C'))
  end

  not_compliant_on :rubinius do
    it.calls " to_i on symbol and returns char with that number with ('C')" do
      [:hello].pack('C').should_equal([:hello.to_i].pack('C'))
    end
  end

  it.raises " a TypeError if value is string with ('C')" do
    lambda { ["hello"].pack('C') }.should_raise(TypeError)
  end

  it.can "processes count number of array elements if count given with ('C')" do
    [1, 2, 3].pack('C3').should_equal("\001\002\003")
    [1, 2, 3].pack('C2C1').should_equal("\001\002\003")
  end

  it.returns "empty string if count = 0 with ('C')" do
    [1, 2, 3].pack('C0').should_equal('')
  end

  it.can "with star parameter processes all remaining array items with ('C')" do
    [1, 2, 3, 4, 5].pack('C*').should_equal("\001\002\003\004\005")
  end

  it.raises " an ArgumentError if count is greater than array elements left with ('C')" do
    lambda { [1, 2].pack('C3') }.should_raise(ArgumentError)
  end

  it.returns "string with char of appropriate number with ('c')" do
    [49].pack('c').should_equal('1')
  end

  it.can "reduces value to fit in byte with ('c')" do
    [257].pack('c').should_equal("\001")
  end

  it.can "convert negative values to positive with ('c')" do
    [-1].pack('c').should_equal([255].pack('C'))
    [-257].pack('c').should_equal([255].pack('C'))
  end

  it.can "convert float to integer and returns char with that number with ('c')" do
    [5.0].pack('c').should_equal([5].pack('c'))
  end

  not_compliant_on :rubinius do
    it.calls " to_i on symbol and returns char with that number with ('c')" do
      [:hello].pack('c').should_equal([:hello.to_i].pack('c'))
    end
  end

  it.raises " a TypeError if value is string with ('c')" do
    lambda { ["hello"].pack('c') }.should_raise(TypeError)
  end

  it.can "processes count number of array elements if count given with ('c')" do
    [1, 2, 3].pack('c3').should_equal("\001\002\003")
  end

  it.returns "empty string if count = 0 with ('c')" do
    [1, 2, 3].pack('c0').should_equal('')
  end

  it.can "with star parameter processes all remaining array items with ('c')" do
    [1, 2, 3, 4, 5].pack('c*').should_equal("\001\002\003\004\005")
  end

  it.raises " an ArgumentError if count is greater than array elements left with ('c')" do
    lambda { [1, 2].pack('c3') }.should_raise(ArgumentError)
  end


  it.can "encodes a high-nibble hexadecimal string with ('H')" do
    ["41"].pack("H2").should_equal("A")
    ["61"].pack("H2").should_equal("a")
    ["7e"].pack("H2").should_equal("~")

    %w(41 31 2a).pack("H2H2H2").should_equal("A1*")
    %w(41312a).pack("H6").should_equal("A1*")
    %w(41312a).pack("H*").should_equal("A1*")
  end
  
  it.can "encodes a low-nibble hexadecimal string with ('h')" do
    ["14"].pack("h2").should_equal("A")
    ["16"].pack("h2").should_equal("a")
    ["e7"].pack("h2").should_equal("~")

    %w(14 13 a2).pack("h2h2h2").should_equal("A1*")
    %w(1413a2).pack("h6").should_equal("A1*")
    %w(1413a2).pack("h*").should_equal("A1*")
  end


  it.can "encodes a positive integer with ('i')" do
    [0].pack('i').should_equal("\000\000\000\000")
    [2**32-1].pack('i').should_equal("\377\377\377\377")
  end

  little_endian do
    it.can "encodes a positive integer in little-endian order with ('i')" do
      [1].pack('i').should_equal("\001\000\000\000")
    end
    
    it.can "encodes 4 positive integers in little-endian order with ('i4')" do
      [1,1234,2,2345].pack('i4').should_equal("\001\000\000\000\322\004\000\000\002\000\000\000)\t\000\000")
    end
    
    it.can "encodes remaining integers in little-endian order with ('i*')" do
      [1,1234,2].pack('i*').should_equal("\001\000\000\000\322\004\000\000\002\000\000\000")
    end
  end
  
  big_endian do
    it.can "encodes a positive integer in big-endian order with ('i')" do
      [1].pack('i').should_equal("\000\000\000\001")
    end
    
    it.can "encodes 4 positive integers in big-endian order with ('i4')" do
      [1,1234,2,2345].pack('i4').should_equal("\000\000\000\001\000\000\004\322\000\000\000\002\000\000\t)")
    end
    
    it.can "encodes remaining integers in big-endian order with ('i*')" do
      [1,1234,2].pack('i*').should_equal("\000\000\000\001\000\000\004\322\000\000\000\002")
    end
  end

  platform_is :wordsize => 64 do
    it.raises " a RangeError when the negative integer is too big with ('s')" do
      lambda { [-2**64].pack('s') }.should_raise(RangeError)
    end

    it.raises " a RangeError when the positive integer is too big with ('i')" do
      lambda { [2**64].pack('i') }.should_raise(RangeError)
    end

    it.raises " a RangeError when the negative integer is too big with ('l')" do
      lambda { [-2**64].pack('l') }.should_raise(RangeError)
    end

    it.raises " a RangeError when the positive integer is too big with ('l')" do
      lambda { [2**64].pack('l') }.should_raise(RangeError)
    end

    it.raises " a RangeError when the positive integer is too big with ('s')" do
      lambda { [2**64].pack('s') }.should_raise(RangeError)
    end
  end

  platform_is :wordsize => 32 do
    it.raises " a RangeError when the negative integer is too big with ('s')" do
      lambda { [-2**32].pack('s') }.should_raise(RangeError)
    end

    it.raises " a RangeError when the positive integer is too big with ('i')" do
      lambda { [2**32].pack('i') }.should_raise(RangeError)
    end

    it.raises " a RangeError when the negative integer is too big with ('l')" do
      lambda { [-2**32].pack('l') }.should_raise(RangeError)
    end

    it.raises " a RangeError when the positive integer is too big with ('l')" do
      lambda { [2**32].pack('l') }.should_raise(RangeError)
    end

    it.raises " a RangeError when the positive integer is too big with ('s')" do
      lambda { [2**32].pack('s') }.should_raise(RangeError)
    end
  end


  it.can "encodes a negative integer with ('i')" do
    [-1].pack('i').should_equal("\377\377\377\377")
  end

  little_endian do
    it.can "encodes a negative integer in little-endian order with ('i')" do
      [-2].pack('i').should_equal("\376\377\377\377")
    end
  end

  big_endian do
    it.can "encodes a negative integer in big-endian order with ('i')" do
      [-2].pack('i').should_equal("\377\377\377\376")
    end
  end

 
  it.can "encodes a positive integer with ('l')" do
    [0].pack('l').should_equal("\000\000\000\000")
    [2**32-1].pack('l').should_equal("\377\377\377\377")
  end

  little_endian do
    it.can "encodes a positive integer in little-endian order with ('l')" do
      [1].pack('l').should_equal("\001\000\000\000")
    end
  end

  big_endian do
    it.can "encodes a positive integer in big-endian order with ('l')" do
      [1].pack('l').should_equal("\000\000\000\001")
    end
  end

  it.can "encodes a negative integer with ('l')" do
    [-1].pack('l').should_equal("\377\377\377\377")
  end

  little_endian do
    it.can "encodes a negative integer in little-endian order with ('l')" do
      [-2].pack('l').should_equal("\376\377\377\377")
    end
  end

  big_endian do
    it.can "encodes a negative integer in big-endian order with ('l')" do
      [-2].pack('l').should_equal("\377\377\377\376")
    end
  end

  it.can "enocdes string with Qouted Printable encoding with ('M')" do
    ["ABCDEF"].pack('M').should_equal("ABCDEF=\n")
  end

  it.does_not " encode new line chars with ('M')" do
    ["\nA"].pack('M').should_equal("\nA=\n")
  end

  it.can "always appends soft line break at the end of encoded string with ('M')" do
    ["ABC"].pack('M')[-2, 2].should_equal("=\n")
  end

  it.can "appends soft line break after each 72 chars + 1 encoded char in encoded string with ('M')" do
    s = ["A"*150].pack('M')
    s[73, 2].should_equal("=\n")
    s[148, 2].should_equal("=\n")

    s = ["A"*72+"\001"].pack('M')
    s[75, 2].should_equal("=\n")
  end

  it.does_not " quote chars 32..60 and 62..126) with ('M')" do
    32.upto(60) do |i|
     [i.chr].pack('M').should_equal(i.chr+"=\n")
    end

    62.upto(126) do |i|
     [i.chr].pack('M').should_equal(i.chr+"=\n")
    end
  end

  it.can "quotes chars by adding equal sign and char's hex value with ('M')" do
    ["\001"].pack('M').should_equal("=01=\n")
  end

  it.can "quotes equal sign with ('M')" do
    ["="].pack('M').should_equal("=3D=\n")
  end

  it.does_not " quote \\t char with ('M')" do
    ["\t"].pack('M').should_equal("\t=\n")
  end

  it.returns "empty string if source string is empty with ('M')" do
    [""].pack('M').should_equal("")
  end

  it.calls " to_s on object to convert to string with ('M')" do
    class X; def to_s; "unnamed object"; end; end

    [123].pack('M').should_equal("123=\n")
    [:hello].pack('M').should_equal("hello=\n")
    [X.new].pack('M').should_equal("unnamed object=\n")
  end

  it.will "ignore count parameter with ('M')" do
    ["ABC", "DEF", "GHI"].pack('M0').should_equal(["ABC"].pack('M'))
    ["ABC", "DEF", "GHI"].pack('M3').should_equal(["ABC"].pack('M'))
  end

  it.will "ignore star parameter with ('M')" do
    ["ABC", "DEF", "GHI"].pack('M*').should_equal(["ABC"].pack('M'))
  end

  it.can "properly handles recursive arrays with ('M')" do
    empty = ArraySpecs.empty_recursive_array
    empty.pack('M').should_equal("[...]=\n")

    array = ArraySpecs.recursive_array
    array.pack('M').should_equal("1=\n")
  end

  it.can "encodes string with Base64 encoding with ('m')" do
    ["ABCDEF"].pack('m').should_equal("QUJDREVG\n")
  end

  it.can "convert series of 3-char sequences into four 4-char sequences with ('m')" do
    ["ABCDEFGHI"].pack('m').size.should_equal(4+4+4+1)
  end

  it.can "fills chars with non-significant bits with '=' sign with ('m')" do
    ["A"].pack('m').should_equal("QQ==\n")
  end

  it.can "appends newline at the end of result string with ('m')" do
    ["A"].pack('m')[-1, 1].should_equal("\n")
  end

  it.can "appends newline after each 60 chars in result string with ('m')" do
    s = ["ABC"*31].pack('m')
    s[60, 1].should_equal("\n")
    s[121, 1].should_equal("\n")
  end

  it.can "encodes 6-bit char less than 26 with capital letters with ('m')" do
    [( 0*4).chr].pack('m').should_equal("AA==\n")
    [( 1*4).chr].pack('m').should_equal("BA==\n")

    [(25*4).chr].pack('m').should_equal("ZA==\n")
  end

  it.can "encodes 6-bit char from 26 to 51 with lowercase letters with ('m')" do
    [(26*4).chr].pack('m').should_equal("aA==\n")
    [(27*4).chr].pack('m').should_equal("bA==\n")

    [(51*4).chr].pack('m').should_equal("zA==\n")
  end

  it.can "encodes 6-bit char 62 with '+' with ('m')" do
    [(62*4).chr].pack('m').should_equal("+A==\n")
  end

  it.can "encodes 6-bit char 63 with '/' with ('m')" do
    [(63*4).chr].pack('m').should_equal("/A==\n")
  end

  it.returns "empty string if source string is empty with ('m')" do
    [""].pack('m').should_equal("")
  end

  it.raises " a TypeError if corresponding array item is not string with ('m')" do
    lambda { [123].pack('m') }.should_raise(TypeError)
    lambda { [:hello].pack('m') }.should_raise(TypeError)
    lambda { [mock('not string')].pack('m') }.should_raise(TypeError)
  end

  it.will "ignore count parameter with ('m')" do
    ["ABC", "DEF", "GHI"].pack('m0').should_equal(["ABC"].pack('m'))
    ["ABC", "DEF", "GHI"].pack('m3').should_equal(["ABC"].pack('m'))
  end

  it.will "ignore star parameter with ('m')" do
    ["ABC", "DEF", "GHI"].pack('m*').should_equal(["ABC"].pack('m'))
  end

  it.can "encodes an integer in network order with ('n')" do
    [1234].pack('n').should_equal("\004\322")
  end

  it.can "encodes 4 integers in network order with ('n4')" do
    [1234,5678,9876,5432].pack('n4').should_equal("\004\322\026.&\224\0258")
  end

  it.can "encodes a long in network-order with ('N')" do
    [1000].pack('N').should_equal("\000\000\003\350")
    [-1000].pack('N').should_equal("\377\377\374\030")

    [65536].pack('N').should_equal("\000\001\000\000")
    [-65536].pack('N').should_equal("\377\377\000\000")
    # TODO: add bigger numbers
  end

#   it.can "encodes a long in network-order with ('N4')" do
#     [1234,5678,9876,5432].pack('N4').should_equal("\000\000\004\322\000\000\026.\000\000&\224\000\000\0258")
#     # TODO: bigger
#   end

  it.can "encodes a long in little-endian order with ('V')" do
    [1000].pack('V').should_equal("\350\003\000\000")
    [-1000].pack('V').should_equal("\030\374\377\377")

    [65536].pack('V').should_equal("\000\000\001\000")
    [-65536].pack('V').should_equal("\000\000\377\377")
    # TODO: add bigger numbers
  end

  it.can "encodes a short in little-endian order with ('v')" do
    [1000].pack('v').should_equal("\350\003")
    [-1000].pack('v').should_equal("\030\374")

    [65536].pack('v').should_equal("\000\000")
    [-65536].pack('v').should_equal("\000\000")
  end

  it.can "encodes a positive integer with ('s')" do
    [0].pack('s').should_equal("\000\000")
    [2**32-1].pack('s').should_equal("\377\377")
  end

  little_endian do
    it.can "encodes a positive integer in little-endian order with ('s')" do
      [1].pack('s').should_equal("\001\000")
    end
  end

  big_endian do
    it.can "encodes a positive integer in big-endian order with ('s')" do
      [1].pack('s').should_equal("\000\001")
    end
  end


  it.can "encodes a negative integer with ('s')" do
    [-1].pack('s').should_equal("\377\377")
  end

  little_endian do
    it.can "encodes a negative integer in little-endian order with ('s')" do
      [-2].pack('s').should_equal("\376\377")
    end
  end

  big_endian do
    it.can "encodes a negative integer in big-endian order with ('s')" do
      [-2].pack('s').should_equal("\377\376")
    end
  end


  it.can "convert integers into UTF-8 encoded byte sequences with ('U')" do
    numbers = [0, 1, 15, 16, 127,
        128, 255, 256, 1024]
    numbers.each do |n|
      [n].pack('U').unpack('U').should_equal([n])
    end
    [0x7F, 0x7F].pack('U*').should_equal("\x7F\x7F")
    [262193, 4736, 191, 12, 107].pack('U*').should_equal("\xF1\x80\x80\xB1\xE1\x8A\x80\xC2\xBF\x0C\x6B")
    [2**16+1, 2**30].pack('U2').should_equal("\360\220\200\201\375\200\200\200\200\200")

    lambda { [].pack('U') }.should_raise(ArgumentError)
    lambda { [1].pack('UU') }.should_raise(ArgumentError)
    lambda { [2**32].pack('U') }.should_raise(RangeError)
    lambda { [-1].pack('U') }.should_raise(RangeError)
    lambda { [-5].pack('U') }.should_raise(RangeError)
    lambda { [-2**32].pack('U') }.should_raise(RangeError)
  end

  it.can "only takes as many elements as specified after ('U')" do
    [?a,?b,?c].pack('U2').should_equal("ab")
  end

  it.can "convert big integers into UTF-8 encoded byte sequences with ('U')" do 
    #these are actually failing on String#unpack
    #  they are not passing the 'utf8_regex_strict' test
    compliant_on :ruby, :jruby, :ir do
      numbers = [ 2048, 4096, 2**16 -1, 2**16, 2**16 + 1, 2**30]
      numbers.each do |n|
        [n].pack('U').unpack('U').should_equal([n])
      end
    end
  end

  it.can "encodes string with UU-encoding with ('u')" do
    ["ABCDEF"].pack('u').should_equal("&04)#1$5&\n")
  end

  it.can "convert series of 3-char sequences into four 4-char sequences with ('u')" do
    ["ABCDEFGHI"].pack('u').size.should_equal(4+4+4+1+1)
  end

  it.can "appends zero-chars to source string if string length is not multiple of 3 with ('u')" do
    ["A"].pack('u').should_equal("!00``\n")
  end

  it.can "appends newline at the end of result string with ('u')" do
    ["A"].pack('u')[-1, 1].should_equal("\n")
  end

  it.can "splits source string into lines with no more than 45 chars with ('u')" do
    s = ["A"*91].pack('u')
    s[61, 1].should_equal("\n")
    s[123, 1].should_equal("\n")
  end

  it.can "prepends encoded line length to each line with ('u')" do
    s = ["A"*50].pack('u')
    s[ 0].should_equal(45+32)
    s[62].should_equal( 5+32)
  end

  it.can "encodes 6-bit char with another char starting from char 32 with ('u')" do
    [( 1 * 4).chr].pack('u').should_equal("!!```\n")
    [(16 * 4).chr].pack('u').should_equal("!0```\n")
    [(25 * 4).chr].pack('u').should_equal("!9```\n")
    [(63 * 4).chr].pack('u').should_equal("!_```\n")
  end

  it.will "replace spaces in encoded string with grave accent (`) char with ('u')" do
    [( 0*4).chr].pack('u').should_equal("!````\n")
  end

  it.returns "empty string if source string is empty with ('u')" do
    [""].pack('u').should_equal("")
  end

  it.raises " a TypeError if corresponding array item is not string with ('u')" do
    lambda { [123].pack('u') }.should_raise(TypeError)
    lambda { [:hello].pack('u') }.should_raise(TypeError)
    lambda { [mock('not string')].pack('u') }.should_raise(TypeError)
  end

  it.will "ignore count parameter with ('u')" do
    ["ABC", "DEF", "GHI"].pack('u0').should_equal(["ABC"].pack('u'))
    ["ABC", "DEF", "GHI"].pack('u3').should_equal(["ABC"].pack('u'))
  end

  it.will "ignore star parameter with ('u')" do
    ["ABC", "DEF", "GHI"].pack('u*').should_equal(["ABC"].pack('u'))
  end

  it.can "decreases result string by one char with ('X')" do
    ['abcdef'].pack('A4X').should_equal('abc')
  end

  describe "with ('w')" do |it| 
    it.can "convert to BER-compressed integer" do
      [0].pack('w').should_equal("\000")
      [1].pack('w').should_equal("\001")
      [0, 1, 2].pack('w2').should_equal("\000\001")
      [0, 1, 2].pack('w*').should_equal("\000\001\002")
      [9999].pack('w').should_equal("\316\017")
      [2**64].pack('w').should_equal("\202\200\200\200\200\200\200\200\200\000")
      lambda { [-1].pack('w') }.should_raise(ArgumentError)
      lambda { [-2**256].pack('w') }.should_raise(ArgumentError)
    end

    it.raises " an ArgumentError if the count is greater than the number of remaining array elements" do
      lambda { [1].pack('w2') }.should_raise(ArgumentError, /few/)
      lambda { [1, 2, 3, 4, 5].pack('w10') }.should_raise(ArgumentError, /few/)
    end

    it.calls " to_int on non-integer values before packing" do
      obj = mock('1')
      obj.should_receive(:to_int).and_return(1)
      [obj].pack('w').should_equal("\001")
    end

    it.raises " TypeError on nil and non-numeric arguments" do
      lambda { [nil].pack('w') }.should_raise(TypeError, /nil/)
      lambda { [()].pack('w') }.should_raise(TypeError, /nil/)
      lambda { ['a'].pack('w') }.should_raise(TypeError, /String/)
      lambda { [Object.new].pack('w') }.should_raise(TypeError, /Object/)
    end
  end

  it.can "with count decreases result string by count chars with ('X')" do
    ['abcdef'].pack('A6X4').should_equal('ab')
  end

  it.can "with zero count doesnt change result string with ('X')" do
    ['abcdef'].pack('A6X0').should_equal('abcdef')
  end

  it.can "treats start parameter as zero count with ('X')" do
    ['abcdef'].pack('A6X*').should_equal('abcdef')
  end

  it.raises " an ArgumentError if count greater than already generated string length with ('X')" do
    lambda { ['abcdef'].pack('A6X7') }.should_raise(ArgumentError)
  end

  it.raises " an ArgumentError if it is first directive with ('X')" do
    lambda { [].pack('X') }.should_raise(ArgumentError)
  end

  it.does_not " increment the array index count with ('X')" do
    ['abcd','efgh'].pack('A4X2A4').should_equal('abefgh')
  end

  it.returns "zero-char string with ('x')" do
    [].pack('x').should_equal("\000")
  end

  it.returns "string of count zero chars with count and ('x')" do
    [].pack('x5').should_equal("\000\000\000\000\000")
  end

  it.returns "empty string with count == 0 and ('x')" do
    [].pack('x0').should_equal("")
  end

  it.behaves "like with count == 0 with star parameter and ('x')" do
    [].pack('x*').should_equal("")
  end

  it.does_not " increment the array index count with ('x')" do
    ['abcd','efgh'].pack('A4x2A4').should_equal("abcd\000\000efgh")
  end

  it.returns "null padded string with ('Z')" do
    ['abcdef'].pack('Z7').should_equal("abcdef\000")
  end

  it.can "cuts string if its size greater than directive count with ('Z')" do
    ['abcde'].pack('Z3').should_equal('abc')
  end

  it.can "considers count = 1 if count omited with ('Z')" do
    ['abcde'].pack('Z').should_equal('a')
  end

  it.returns "empty string if count = 0 with ('Z')" do
    ['abcde'].pack('Z0').should_equal('')
  end

  it.returns "the whole argument string plus null char with star parameter with ('Z')" do
    ['abcdef'].pack('Z*').should_equal("abcdef\000")
  end

  it.raises " a TypeError if array item is not String with ('Z')" do
    lambda { [123].pack('Z5') }.should_raise(TypeError)
    lambda { [:hello].pack('Z5') }.should_raise(TypeError)
    lambda { [mock('not string')].pack('Z5') }.should_raise(TypeError)
  end

  # Scenario taken from Mongrel's use of the SO_ACCEPTFILTER struct
  it.can "reuses last array element as often as needed to complete the string" do
    expected = "httpready" + ("\000" * 247)
    ['httpready', nil].pack('a16a240').should_equal(expected)
  end
end
