# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Array#==" do |it| 
  it.returns " true if the other is self" do
    a = [1, 2, 3]
    a.should_equal(a)
  end

  it.returns "true if each element is == to the corresponding element in the other array" do
    [].should_equal([])
    ["a", "c", 7].should_equal(["a", "c", 7])

    [1, 2, 3].should_equal([1.0, 2.0, 3.0])

    obj = mock('5')
    def obj.==(other) true end
    [obj].should_equal([5])
  end

  it.returns "false if the other is shorter than self" do
    a = [1, 2, 3]
    b = [1, 2]
    a.should_not == b
  end
  
  it.returns "false if the other is longer than self" do
    a = [1, 2, 3]
    b = [1, 2, 3, 4]
    a.should_not == b
  end
  
  it.returns "false if any element is not == to the corresponding element in the other the array" do
    a = ["a", "b", "c"]
    b = ["a", "b", "not equal value"]
    a.should_not == b

    c = "c"
    def c.==(x); false end
    ["a", "b", c].should_not == a
  end
  
  it.returns "false immediately when sizes of the arrays differ" do
    obj = mock('1')
    obj.should_not_receive(:==)
    
    [].should_not == [obj]
    [obj].should_not == []
  end

  it.can "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    empty2 = []; empty2 << empty2
    (empty == empty.dup).should_be_true
    (empty == empty2).should_be_false

    array = ArraySpecs.recursive_array
    (array == array).should_be_true
    (array == array.dup).should_be_true
    (array == empty).should_be_false
    (array == [1, 2]).should_be_false
  end

  # Broken in MRI as well. See MRI bug #11585:
  # http://rubyforge.org/tracker/index.php?func=detail&aid=11585&group_id=426&atid=1698
  compliant_on :r19, :jruby, :ir  do
    it.calls " to_ary on its argument" do
      obj = mock('to_ary')
      obj.should_receive(:to_ary).and_return([1, 2, 3])
    
      [1, 2, 3].should_equal(obj)
    end
  end
  
  it.does_not "call to_ary on array subclasses" do
    [5, 6, 7].should_equal(ArraySpecs::ToAryArray[5, 6, 7])
  end

  it.will "ignore array class differences" do
    ArraySpecs::MyArray[1, 2, 3].should_equal([1, 2, 3])
    ArraySpecs::MyArray[1, 2, 3].should_equal(ArraySpecs::MyArray[1, 2, 3])
    [1, 2, 3].should_equal(ArraySpecs::MyArray[1, 2, 3])
  end

  it.can "can be assymetric (but should not)" do
    bad_array = ArraySpecs::MyArray[1, 2, 3]
    def bad_array.==(x) false end
    [1, 2, 3].should_equal(bad_array)
    bad_array.should_not == [1, 2, 3]
  end
end
