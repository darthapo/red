# require File.dirname(__FILE__) + '/../spec_helper'

describe "Literal Regexps" do |it| 
  it.can "matches against $_ (last input) in a conditional if no explicit matchee provided" do
    $_ = nil

    (true if /foo/).should_not == true

    $_ = "foo"

    (true if /foo/).should_equal(true)
  end

  it.can "allow substitution of strings" do
    str = "o?$"
    (/fo#{str}/ =~ "foo?").should_equal(nil)
    (/fo#{str}/ =~ "foo").should_equal(0)
  end

  it.can "allow substitution of literal regexps" do
    str = /o?$/
    (/fo#{str}/ =~ "foo?").should_equal(nil)
    (/fo#{str}/ =~ "foo").should_equal(0)
  end
  
  it.can "matches . to newlines if Regexp::MULTILINE is specified" do
    str = "abc\ndef"
    (str =~ /.def/).should_equal(nil )
    (str =~ /.def/m).should_equal(3)
  end
end
