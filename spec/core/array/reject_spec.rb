# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Array#reject" do |it| 
  it.returns "a new array without elements for which block is true" do
    ary = [1, 2, 3, 4, 5]
    ary.reject { true }.should_equal([])
    ary.reject { false }.should_equal(ary)
    ary.reject { nil }.should_equal(ary)
    ary.reject { 5 }.should_equal([])
    ary.reject { |i| i < 3 }.should_equal([3, 4, 5])
    ary.reject { |i| i % 2 == 0 }.should_equal([1, 3, 5])
  end

  it.can "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    empty.reject { false }.should_equal([empty])
    empty.reject { true }.should_equal([])

    array = ArraySpecs.recursive_array
    array.reject { false }.should_equal([1, 'two', 3.0, array, array, array, array, array])
    array.reject { true }.should_equal([])
  end
  
  # Returns ArraySpecs::MyArray on MRI 1.8 which is inconsistent with select.
  # It has been changed on 1.9 however.
  compliant_on :ruby, :jruby do
    it.returns "subclass instance on Array subclasses" do
      ArraySpecs::MyArray[1, 2, 3].reject { |x| x % 2 == 0 }.class.should_equal(ArraySpecs::MyArray)
    end
  end
  
  deviates_on(:r19, :rubinius, :ir) do
    it.does_not "return subclass instance on Array subclasses" do
      ArraySpecs::MyArray[1, 2, 3].reject { |x| x % 2 == 0 }.class.should_equal(Array)
    end
  end
end

describe "Array#reject!" do |it| 
  it.can "removes elements for which block is true" do
    a = [3, 4, 5, 6, 7, 8, 9, 10, 11]
    a.reject! { |i| i % 2 == 0 }.should_equal(a)
    a.should_equal([3, 5, 7, 9, 11])
    a.reject! { |i| i > 8 }
    a.should_equal([3, 5, 7])
    a.reject! { |i| i < 4 }
    a.should_equal([5, 7])
    a.reject! { |i| i == 5 }
    a.should_equal([7])
    a.reject! { true }
    a.should_equal([])
    a.reject! { true }
    a.should_equal([])
  end

  it.can "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    empty_dup = empty.dup
    empty.reject! { false }.should_equal(nil)
    empty.should_equal(empty_dup)

    empty = ArraySpecs.empty_recursive_array
    empty.reject! { true }.should_equal([])
    empty.should_equal([])

    array = ArraySpecs.recursive_array
    array_dup = array.dup
    array.reject! { false }.should_equal(nil)
    array.should_equal(array_dup)

    array = ArraySpecs.recursive_array
    array.reject! { true }.should_equal([])
    array.should_equal([])
  end

  it.returns "nil if no changes are made" do
    a = [1, 2, 3]
    
    a.reject! { |i| i < 0 }.should_equal(nil)
    
    a.reject! { true }
    a.reject! { true }.should_equal(nil)
  end

  compliant_on :ruby, :jruby, :ir do
    it.raises " a TypeError on a frozen array" do
      lambda { ArraySpecs.frozen_array.reject! {} }.should_raise(TypeError)
    end
  end
end
