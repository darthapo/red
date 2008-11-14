# require File.dirname(__FILE__) + '/../../spec_helper'

ruby_version_is "1.8.7" do
  describe "Integer#even?" do |it| 
    it.returns "true when self is an even number" do
      (-2).even?.should_be_true
      (-1).even?.should_be_false

      0.even?.should_be_true
      1.even?.should_be_false
      2.even?.should_be_true

      bignum_value(0).even?.should_be_true
      bignum_value(1).even?.should_be_false

      (-bignum_value(0)).even?.should_be_true
      (-bignum_value(1)).even?.should_be_false
    end
  end
end