# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Array#push" do |it| 
  it.can "appends the arguments to the array" do
    a = [ "a", "b", "c" ]
    a.push("d", "e", "f").should_equal(a)
    a.push().should_equal(["a", "b", "c", "d", "e", "f"])
    a.push(5)
    a.should_equal(["a", "b", "c", "d", "e", "f", 5])
  end

  it.can "isn't confused by previous shift" do
    a = [ "a", "b", "c" ]
    a.shift
    a.push("foo")
    a.should_equal(["b", "c", "foo"])
  end

  it.can "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    empty.push(:last).should_equal([empty, :last])

    array = ArraySpecs.recursive_array
    array.push(:last).should_equal([1, 'two', 3.0, array, array, array, array, array, :last])
  end

  compliant_on :ruby, :jruby, :ir do
    it.raises " a TypeError on a frozen array if modification takes place" do
      lambda { ArraySpecs.frozen_array.push(1) }.should_raise(TypeError)
    end

    it.does_not "raise on a frozen array if no modification is made" do
      ArraySpecs.frozen_array.push.should_equal([1, 2, 3])
    end
  end
end
