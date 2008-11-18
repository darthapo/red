# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/shared/new'

describe "Regexp.new" do |it| 
  it.behaves_like :regexp_new, :new
end

describe "Regexp.new given a String" do |it| 
  it.behaves_like :regexp_new_string, :compile
end

describe "Regexp.new given a Regexp" do |it| 
  it.behaves_like :regexp_new_regexp, :compile
end
