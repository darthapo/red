# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Comparable#==" do |it| 
  it.returns "true if other is the same as self" do
    a = ComparableSpecs::Weird.new(0)
    b = ComparableSpecs::Weird.new(20)
    
    (a == a).should_equal(true)
    (b == b).should_equal(true)
  end
  
  it.calls " #<=> on self with other and returns true if #<=> returns 0" do
    a = ComparableSpecs::Weird.new(0)
    b = ComparableSpecs::Weird.new(10)
    
    a.should_receive(:<=>).any_number_of_times.and_return(0)
    (a == b).should_equal(true)

    a = ComparableSpecs::Weird.new(0)
    a.should_receive(:<=>).any_number_of_times.and_return(0.0)
    (a == b).should_equal(true)
  end
  
  it.returns "false if calling #<=> on self returns a non-zero Integer" do
    a = ComparableSpecs::Weird.new(0)
    b = ComparableSpecs::Weird.new(10)
 
    a.should_receive(:<=>).any_number_of_times.and_return(1)
    (a == b).should_equal(false)
    
    a = ComparableSpecs::Weird.new(0)
    a.should_receive(:<=>).any_number_of_times.and_return(-1)
    (a == b).should_equal(false)
  end
  
  it.returns "nil if calling #<=> on self returns nil or a non-Integer" do
    a = ComparableSpecs::Weird.new(0)
    b = ComparableSpecs::Weird.new(10)

    a.should_receive(:<=>).any_number_of_times.and_return(nil)
    (a == b).should_equal(nil)

    a = ComparableSpecs::Weird.new(0)
    a.should_receive(:<=>).any_number_of_times.and_return("abc")
    (a == b).should_equal(nil)
  end

  it.returns "nil if calling #<=> on self raises a StandardError" do
    a = ComparableSpecs::Weird.new(0)
    b = ComparableSpecs::Weird.new(10)
    
    def a.<=>(b) raise StandardError, "test"; end
    (a == b).should_equal(nil)

    # TypeError < StandardError
    def a.<=>(b) raise TypeError, "test"; end
    (a == b).should_equal(nil)

    def a.<=>(b) raise Exception, "test"; end
    lambda { (a == b).should_equal(nil }.should_raise(Exception))
  end
end
