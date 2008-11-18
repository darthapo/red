# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#to_i" do |it| 
  it.will "ignore leading whitespaces" do
    [ " 123", "     123", "\r\n\r\n123", "\t\t123",
      "\r\n\t\n123", " \t\n\r\t 123"].each do |str|
      str.to_i.should_equal(123)
    end
  end
  
  it.will "ignore leading underscores" do
    "_123".to_i.should_equal(123)
    "__123".to_i.should_equal(123)
    "___123".to_i.should_equal(123)
  end
  
  it.will "ignore underscores in between the digits" do
    "1_2_3asdf".to_i.should_equal(123)
  end
  
  it.will "ignore subsequent invalid characters" do
    "123asdf".to_i.should_equal(123)
    "123#123".to_i.should_equal(123)
    "123 456".to_i.should_equal(123)
  end
  
  it.returns "0 if self is no valid integer-representation" do
    [ "++2", "+-2", "--2" ].each do |str|
      str.to_i.should_equal(0)
    end
  end
  
  it.will "ignore a leading mix of whitespaces and underscores" do
    [ "_ _123", "_\t_123", "_\r\n_123" ].each do |str|
      str.to_i.should_equal(123)
    end
  end

  it.will "interpret leading characters as a number in the given base" do
    "100110010010".to_i(2).should_equal(0b100110010010)
    "100110201001".to_i(3).should_equal(186409)
    "103110201001".to_i(4).should_equal(5064769)
    "103110241001".to_i(5).should_equal(55165126)
    "153110241001".to_i(6).should_equal(697341529)
    "153160241001".to_i(7).should_equal(3521513430)
    "153160241701".to_i(8).should_equal(14390739905)
    "853160241701".to_i(9).should_equal(269716550518)
    "853160241791".to_i(10).should_equal(853160241791)
    
    "F00D_BE_1337".to_i(16).should_equal(0xF00D_BE_1337)
    "-hello_world".to_i(32).should_equal(-18306744)
    "abcXYZ".to_i(36).should_equal(623741435)
    
    ("z" * 24).to_i(36).should_equal(22452257707354557240087211123792674815)

    "5e10".to_i.should_equal(5)
  end
  
  it.wil "auto-detects base 8 via leading 0 when base = 0" do
    "01778".to_i(0).should_equal(0177)
    "-01778".to_i(0).should_equal(-0177)
  end

  it.will "auto-detects base 2 via 0b when base = 0" do
    "0b112".to_i(0).should_equal(0b11)
    "-0b112".to_i(0).should_equal(-0b11)
  end

  it.will "auto-detects base 10 via 0d when base = 0" do
    "0d19A".to_i(0).should_equal(19)
    "-0d19A".to_i(0).should_equal(-19)
  end

  it.will "auto-detect base 8 via 0o when base = 0" do
    "0o178".to_i(0).should_equal(0o17)
    "-0o178".to_i(0).should_equal(-0o17)
  end

  it.will "auto-detect base 16 via 0x when base = 0" do
    "0xFAZ".to_i(0).should_equal(0xFA)
    "-0xFAZ".to_i(0).should_equal(-0xFA)
  end

  it.will "auto-detect base 10 with no base specifier when base = 0" do
    "1234567890ABC".to_i(0).should_equal(1234567890)
    "-1234567890ABC".to_i(0).should_equal(-1234567890)
  end

  it.does_not " handle foreign base specifiers when base is > 0" do
    [2, 3, 4, 8, 10].each do |base|
      "0111".to_i(base).should_equal("111".to_i(base))
      
      "0b11".to_i(base).should_equal((base ==  2 ? 0b11 : 0))
      "0d11".to_i(base).should_equal((base == 10 ? 0d11 : 0))
      "0o11".to_i(base).should_equal((base ==  8 ? 0o11 : 0))
      "0xFA".to_i(base).should_equal(0)
    end
    
    "0xD00D".to_i(16).should_equal(0xD00D)
    
    "0b11".to_i(16).should_equal(0xb11)
    "0d11".to_i(16).should_equal(0xd11)
    "0o11".to_i(25).should_equal(15026)
    "0x11".to_i(34).should_equal(38183)
  end
  
  it.tries "to convert the base to an integer using to_int" do
    obj = mock('8')
    def obj.to_int() 8 end
    
    "777".to_i(obj).should_equal(0777)

    obj = mock('8')
    obj.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_int).and_return(8)

    "777".to_i(obj).should_equal(0777)
  end
  
  it.requires " that the sign if any appears before the base specifier" do
    "0b-1".to_i( 2).should_equal(0)
    "0d-1".to_i(10).should_equal(0)
    "0o-1".to_i( 8).should_equal(0)
    "0x-1".to_i(16).should_equal(0)

    "0b-1".to_i(2).should_equal(0)
    "0o-1".to_i(8).should_equal(0)
    "0d-1".to_i(10).should_equal(0)
    "0x-1".to_i(16).should_equal(0)
  end
  
  it.raises " an ArgumentError for illegal bases (1, < 0 or > 36)" do
    lambda { "".to_i(1)  }.should_raise(ArgumentError)
    lambda { "".to_i(-1) }.should_raise(ArgumentError)
    lambda { "".to_i(37) }.should_raise(ArgumentError)
  end
end
