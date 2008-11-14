# require File.dirname(__FILE__) + '/../../spec_helper'

describe "ScriptError" do |it| 
   it.is_a " superclass of LoadError" do
     ScriptError.should_be_ancestor_of(LoadError)
   end

   it.is_a " superclass of NotImplementedError" do
     ScriptError.should_be_ancestor_of(NotImplementedError)
   end

   it.is_a " superclass of SyntaxError" do
     ScriptError.should_be_ancestor_of(SyntaxError)
   end
end
