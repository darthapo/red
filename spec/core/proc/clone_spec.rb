# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/shared/dup'

describe "Proc#clone" do |it| 
  it.behaves_like(:proc_dup, :clone)
end