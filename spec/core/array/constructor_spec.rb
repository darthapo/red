# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Array.[]" do |it| 
  it.returns "a new array populated with the given elements" do
    obj = Object.new
    Array.[](5, true, nil, 'a', "Ruby", obj).should_equal([5, true, nil, "a", "Ruby", obj])

    a = ArraySpecs::MyArray.[](5, true, nil, 'a', "Ruby", obj)
    a.class.should_equal(ArraySpecs::MyArray)
    a.inspect.should_equal([5, true, nil, "a", "Ruby", obj].inspect)
  end
end

describe "Array[]" do |it| 
  it.can "be a synonym for .[]" do
    obj = Object.new
    Array[5, true, nil, 'a', "Ruby", obj].should_equal(Array.[](5, true, nil, "a", "Ruby", obj))

    a = ArraySpecs::MyArray[5, true, nil, 'a', "Ruby", obj]
    a.class.should_equal(ArraySpecs::MyArray)
    a.inspect.should_equal([5, true, nil, "a", "Ruby", obj].inspect)
  end
end
