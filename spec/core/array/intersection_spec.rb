# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Array#&" do |it| 
  it.creates "an array with elements common to both arrays (intersection)" do
    ([] & []).should_equal([])
    ([1, 2] & []).should_equal([])
    ([] & [1, 2]).should_equal([])
    ([ 1, 3, 5 ] & [ 1, 2, 3 ]).should_equal([1, 3])
  end
  
  it.creates "an array with no duplicates" do
    ([ 1, 1, 3, 5 ] & [ 1, 2, 3 ]).uniq!.should_equal(nil)
  end
  
  it.creates "an array with elements in order they are first encountered" do
    ([ 1, 2, 3, 2, 5 ] & [ 5, 2, 3, 4 ]).should_equal([2, 3, 5])
  end

  it.does_not "modify the original Array" do
    a = [1, 1, 3, 5]
    a & [1, 2, 3]
    a.should_equal([1, 1, 3, 5])
  end

  it.can "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    (empty & empty).should_equal(empty)

    (ArraySpecs.recursive_array & []).should_equal([])
    ([] & ArraySpecs.recursive_array).should_equal([])

    (ArraySpecs.recursive_array & ArraySpecs.recursive_array).should_equal([1, 'two', 3.0])
  end

  it.tries "to convert the passed argument to an Array using #to_ary" do
    obj = mock('[1,2,3]')
    obj.should_receive(:to_ary).and_return([1, 2, 3])
    ([1, 2] & obj).should_equal(([1, 2]))
  end
  
  it.checks "whether the passed argument responds to #to_ary" do
    obj = mock('[1,2,3]')
    obj.should_receive(:respond_to?).with(:to_ary).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_ary).and_return([1, 2, 3])
    ([1, 2] & obj).should_equal([1, 2])
  end

  it.can "determines equivalence between elements in the sense of eql?" do
    ([5.0, 4.0] & [5, 4]).should_equal([])
    str = "x"
    ([str] & [str.dup]).should_equal([str])
    
    obj1 = mock('1')
    obj2 = mock('2')
    def obj1.hash; 0; end
    def obj2.hash; 0; end
    def obj1.eql? a; true; end
    def obj2.eql? a; true; end
    
    ([obj1] & [obj2]).should_equal([obj1])
    
    def obj1.eql? a; false; end
    def obj2.eql? a; false; end
    
    ([obj1] & [obj2]).should_equal([])
  end
  
  it.can "does return subclass instances for Array subclasses" do
    (ArraySpecs::MyArray[1, 2, 3] & []).class.should_equal(Array)
    (ArraySpecs::MyArray[1, 2, 3] & ArraySpecs::MyArray[1, 2, 3]).class.should_equal(Array)
    ([] & ArraySpecs::MyArray[1, 2, 3]).class.should_equal(Array)
  end

  it.does_not "call to_ary on array subclasses" do
    ([5, 6] & ArraySpecs::ToAryArray[1, 2, 5, 6]).should_equal([5, 6])
  end  
end
