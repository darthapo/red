# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'
# require File.dirname(__FILE__) + '/shared/concat.rb'

describe "String#<<" do |it| 
  it.behaves_like :string_concat, :<<
end

describe "String#<< with Fixnum" do |it| 
  it.behaves_like :string_concat_fixnum, :<<
end
