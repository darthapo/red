# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/shared/modulo'

describe "Bignum#%" do |it| 
  it.behaves_like(:bignum_modulo, :%)
end

describe "Bignum#modulo" do |it| 
  it.behaves_like(:bignum_modulo, :modulo)
end
