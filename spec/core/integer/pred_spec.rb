# require File.dirname(__FILE__) + '/../../spec_helper'

ruby_version_is "1.8.7" do
  describe "Integer#pred" do |it| 
    it.returns "the Integer equal to self - 1" do
      0.pred.should_equal(-1) 
      -1.pred.should_equal(-2)
      bignum_value.pred.should_equal(bignum_value(-1))
      20.pred.should_equal(19)
    end
  end
end