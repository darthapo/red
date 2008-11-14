# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Regexp#kcode" do |it| 
  it.returns "the character set code" do
    default = /f.(o)/.kcode
    default.should_not == 'sjis'
    default.should_not == 'euc'
    default.should_not == 'utf8'

    /ab+c/s.kcode.should_equal("sjis")
    /a(.)+s/n.kcode.should_equal("none")
    /xyz/e.kcode.should_equal("euc")
    /cars/u.kcode.should_equal("utf8")
  end
end
