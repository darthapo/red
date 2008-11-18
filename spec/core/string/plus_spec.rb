# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#+" do |it| 
  it.returns "a new string containing the given string concatenated to self" do
    ("" + "").should_equal("")
    ("" + "Hello").should_equal("Hello")
    ("Hello" + "").should_equal("Hello")
    ("Ruby !" + "= Rubinius").should_equal("Ruby != Rubinius")
  end

  it.can "convert any non-String argument with #to_str" do
    c = mock 'str'
    c.should_receive(:to_str).any_number_of_times.and_return(' + 1 = 2')

    ("1" + c).should_equal('1 + 1 = 2')
  end

  it.raises " a TypeError when given any object that fails #to_str" do
    lambda { "" + Object.new }.should_raise(TypeError)
    lambda { "" + 65 }.should_raise(TypeError)
  end

  it.does_not " return subclass instances" do
    (StringSpecs::MyString.new("hello") + "").class.should_equal(String)
    (StringSpecs::MyString.new("hello") + "foo").class.should_equal(String)
    (StringSpecs::MyString.new("hello") + StringSpecs::MyString.new("foo")).class.should_equal(String)
    (StringSpecs::MyString.new("hello") + StringSpecs::MyString.new("")).class.should_equal(String)
    (StringSpecs::MyString.new("") + StringSpecs::MyString.new("")).class.should_equal(String)
    ("hello" + StringSpecs::MyString.new("foo")).class.should_equal(String)
    ("hello" + StringSpecs::MyString.new("")).class.should_equal(String)
  end

  it.will "taint the result when self or other is tainted" do
    strs = ["", "OK", StringSpecs::MyString.new(""), StringSpecs::MyString.new("OK")]
    strs += strs.map { |s| s.dup.taint }

    strs.each do |str|
      strs.each do |other|
        (str + other).tainted?.should_equal((str.tainted? | other.tainted?))
      end
    end
  end
end
