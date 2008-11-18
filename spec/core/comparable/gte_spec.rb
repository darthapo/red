# require File.dirname(__FILE__) + '/fixtures/classes'
# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Comparable#>=" do |it| 
  it.calls " #<=> on self with other and returns true if #<=> returns 0 or any Integer greater than 0" do
    a = ComparableSpecs::Weird.new(0)
    b = ComparableSpecs::Weird.new(20)

    a.should_receive(:<=>).any_number_of_times.and_return(0)
    (a >= b).should_equal(true)
    
    a.should_receive(:<=>).any_number_of_times.and_return(0.0)
    (a >= b).should_equal(true)
    
    a.should_receive(:<=>).any_number_of_times.and_return(1)
    (a >= b).should_equal(true)

    a.should_receive(:<=>).any_number_of_times.and_return(0.1)
    (a >= b).should_equal(true)

    a.should_receive(:<=>).any_number_of_times.and_return(10000000)
    (a >= b).should_equal(true)
  end

  it.returns "false if calling #<=> on self returns any Integer less than 0" do
    a = ComparableSpecs::Weird.new(0)
    b = ComparableSpecs::Weird.new(10)
 

    a.should_receive(:<=>).any_number_of_times.and_return(-0.1)
    (a >= b).should_equal(false)
    
    a.should_receive(:<=>).any_number_of_times.and_return(-1.0)
    (a >= b).should_equal(false)
    
    a.should_receive(:<=>).any_number_of_times.and_return(-10000000)
    (a >= b).should_equal(false)
  end

  it.raises " an ArgumentError if calling #<=> on self returns nil" do
    a = ComparableSpecs::Weird.new(0)
    b = ComparableSpecs::Weird.new(20)
    
    a.should_receive(:<=>).any_number_of_times.and_return(nil)
    lambda { (a >= b) }.should_raise(ArgumentError)
  end
end