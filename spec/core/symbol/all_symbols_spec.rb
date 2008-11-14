# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Symbol.all_symbols" do |it| 
  it.returns "an array containing all the Symbols in the symbol table" do
    Symbol.all_symbols.is_a?(Array).should_equal(true)
    Symbol.all_symbols.all? { |s| s.is_a?(Symbol) ? true : (p s; false) }.should_equal(true)
  end
  # it.is_a " pain in the ass to test..."
end
