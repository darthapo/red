# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Fixnum#**" do |it| 
  it.returns "self raised to the given power" do
    (2 ** 0).should_equal(1)
    (2 ** 1).should_equal(2)
    (2 ** 2).should_equal(4)

    (9 ** 0.5).to_s.should_equal('3.0')
    (5 ** -1).to_f.to_s.should_equal('0.2')

    (2 ** 40).should_equal(1099511627776)
  end
end
