# require File.dirname(__FILE__) + '/../spec_helper'

describe "Ruby numbers in various ways" do |it| 

  it.can "the standard way" do
    435.should_equal(435)
  end

  it.can "with underscore separations" do
    4_35.should_equal(435)
  end

  it.can "with some decimals" do
    4.35.should_equal(4.35)
  end
  
  it.can "with decimals but no integer part should be a SyntaxError" do
    lambda { eval(".75")  }.should_raise(SyntaxError)
    lambda { eval("-.75") }.should_raise(SyntaxError)
  end

  # TODO : find a better description
  it.can "using the e expression" do
    1.2e-3.should_equal(0.0012)
  end

  it.can "the hexdecimal notation" do
    0xffff.should_equal(65535)
  end

  it.can "the binary notation" do
    0b01011.should_equal(11)
  end

  it.can "octal representation" do
    0377.should_equal(255)
  end

  it.can "character to numeric shortcut" do
    ?z.should_equal(122)
  end

  it.can "character with control character to numeric shortcut" do
    # Control-Z
    ?\C-z.should_equal(26)

    # Meta-Z
    ?\M-z.should_equal(250)

    # Meta-Control-Z
    ?\M-\C-z.should_equal(154)
  end

end
