# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/shared/new'

describe "Range.compile" do |it| 
  it.behaves_like :regexp_new, :compile
end

describe "Regexp.compile given a String" do |it| 
  it.behaves_like :regexp_new_string, :compile
end

describe "Regexp.compile given a Regexp" do |it| 
  it.behaves_like :regexp_new_regexp, :compile
end
