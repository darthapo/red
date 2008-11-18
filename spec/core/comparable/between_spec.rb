# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Comparable#between?" do |it| 
  it.returns "true if self is greater than or equal to the first and less than or equal to the second argument" do
    a = ComparableSpecs::Weird.new(-1)
    b = ComparableSpecs::Weird.new(0)
    c = ComparableSpecs::Weird.new(1)
    d = ComparableSpecs::Weird.new(2)

    a.between?(a, a).should_equal(true)
    a.between?(a, b).should_equal(true)
    a.between?(a, c).should_equal(true)
    a.between?(a, d).should_equal(true)
    c.between?(c, d).should_equal(true)
    d.between?(d, d).should_equal(true)
    c.between?(a, d).should_equal(true)
    
    a.between?(b, b).should_equal(false)
    a.between?(b, c).should_equal(false)
    a.between?(b, d).should_equal(false)
    c.between?(a, a).should_equal(false)
    c.between?(a, b).should_equal(false)
  end
end
