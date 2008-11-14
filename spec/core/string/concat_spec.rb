# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'
# require File.dirname(__FILE__) + '/shared/concat.rb'

describe "String#concat" do |it| 
  it.behaves_like :string_concat, :concat
end

describe "String#concat with Fixnum" do |it| 
  it.behaves_like :string_concat_fixnum, :concat
end
