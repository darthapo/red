# require File.dirname(__FILE__) + '/../../spec_helper'

extended_on :rubinius do
  describe "String#each_char" do |it| 
    it.will "passe each char in self to the given block" do
      a = []
      "hello".each_char { |c| a << c }
      a.should_equal(['h', 'e', 'l', 'l', 'o'])
    end
  end
end
