# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/shared/call'

describe "Proc#[]" do |it| 
  it.behaves_like :proc_call, :[]
end

describe "Proc#call on a Proc created with Proc.new" do |it| 
  it.behaves_like :proc_call_on_proc_new, :call
end

describe "Proc#call on a Proc created with Kernel#lambda or Kernel#proc" do |it| 
  it.behaves_like :proc_call_on_proc_or_lambda, :call
end
