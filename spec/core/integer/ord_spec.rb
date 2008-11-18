# require File.dirname(__FILE__) + '/../../spec_helper'

ruby_version_is "1.8.7" do
  describe "Integer#ord" do |it| 
    it.returns "self" do
      20.ord.should_equal(20)
      40.ord.should_equal(40)
      
      0.ord.should_equal(0)
      (-10).ord.should_equal(-10)
      
      ?a.ord.should_equal(97)
      ?Z.ord.should_equal(90)
      
      bignum_value.ord.should_equal(bignum_value)
      (-bignum_value).ord.should_equal(-bignum_value)
    end
  end
end
