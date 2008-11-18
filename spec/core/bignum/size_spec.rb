# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Bignum#size" do |it| 
  it.returns "the number of bytes in the machine representation of self" do
    compliant_on(:ruby, :ironruby) do
      (256**7).size.should_equal(8)
      (256**8).size.should_equal(12)
      (256**9).size.should_equal(12)
      (256**10).size.should_equal(12)
      (256**10-1).size.should_equal(12)
      (256**11).size.should_equal(12)
      (256**12).size.should_equal(16)
      (256**20-1).size.should_equal(20)
      (256**40-1).size.should_equal(40)
    end

    compliant_on(:rubinius, :jruby) do
      (256**7).size   .should_equal(8)
      (256**8).size   .should_equal(9)
      (256**9).size   .should_equal(10)
      (256**10).size  .should_equal(11)
      (256**10-1).size.should_equal(10)
      (256**11).size   .should_equal(12)
      (256**12).size   .should_equal(13)
      (256**20-1).size .should_equal(20)
      (256**40-1).size .should_equal(40)
    end
  end
end
