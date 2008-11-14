# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#=~" do |it| 
  it.behaves "the same way as index() when given a regexp" do
    ("rudder" =~ /udder/).should_equal("rudder".index(/udder/))
    ("boat" =~ /[^fl]oat/).should_equal("boat".index(/[^fl]oat/))
    ("bean" =~ /bag/).should_equal("bean".index(/bag/))
    ("true" =~ /false/).should_equal("true".index(/false/))
  end

  it.raises " a TypeError if a obj is a string" do
    lambda { "some string" =~ "another string" }.should_raise(TypeError)
    lambda { "a" =~ StringSpecs::MyString.new("b")          }.should_raise(TypeError)
  end
  
  it.will "invoke obj.=~ with self if obj is neither a string nor regexp" do
    str = "w00t"
    obj = mock('x')

    obj.should_receive(:=~).with(str).any_number_of_times.and_return(true)
    str.should =~ obj

    obj = mock('y')
    obj.should_receive(:=~).with(str).any_number_of_times.and_return(false)
    str.should_not =~ obj
  end
  
  it.will "set $~ to MatchData when there is a match and nil when there's none" do
    'hello' =~ /./
    $~[0].should_equal('h')
    
    'hello' =~ /not/
    $~.should_equal(nil)
  end
end

describe "String#match" do |it| 
  it.will "match the pattern against self" do
    'hello'.match(/(.)\1/)[0].should_equal('ll')
  end
  
  it.tries "to convert pattern to a string via to_str" do
    obj = mock('.')
    def obj.to_str() "." end
    "hello".match(obj)[0].should_equal("h")
    
    obj = mock('.')
    def obj.respond_to?(type) true end
    def obj.method_missing(*args) "." end
    "hello".match(obj)[0].should_equal("h"    )
  end
  
  it.raises " a TypeError if pattern is not a regexp or a string" do
    lambda { 'hello'.match(10)   }.should_raise(TypeError)
    lambda { 'hello'.match(:ell) }.should_raise(TypeError)
  end

  it.can "convert string patterns to regexps without escaping" do
    'hello'.match('(.)\1')[0].should_equal('ll')
  end
  
  it.returns "nil if there's no match" do
    'hello'.match('xx').should_equal(nil)
  end

  it.will "match \\G at the start of the string" do
    'hello'.match(/\Gh/)[0].should_equal('h')
    'hello'.match(/\Go/).should_equal(nil)
  end

  it.will "set $~ to MatchData of match or nil when there is none" do
    'hello'.match(/./)
    $~[0].should_equal('h')
    Regexp.last_match[0].should_equal('h')

    'hello'.match(/X/)
    $~.should_equal(nil)
    Regexp.last_match.should_equal(nil)
  end
end
