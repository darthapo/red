# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Array#flatten" do |it| 
  it.returns "a one-dimensional flattening recursively" do
    [[[1, [2, 3]],[2, 3, [4, [4, [5, 5]], [1, 2, 3]]], [4]], []].flatten.should_equal([1, 2, 3, 2, 3, 4, 4, 5, 5, 1, 2, 3, 4])
  end
  
  ruby_version_is "1.8.7" do
    it.can "take an optional argument that determines the level of recursion" do
      [ 1, 2, [3, [4, 5] ] ].flatten(1).should_equal([1, 2, 3, [4, 5]])
    end
    
    it.returns "self when the level of recursion is 0" do
      a = [ 1, 2, [3, [4, 5] ] ]
      a.flatten(0).should_equal(a)
    end
    
    it.will "ignore negative levels" do
      [ 1, 2, [ 3, 4, [5, 6] ] ].flatten(-1).should_equal([1, 2, 3, 4, 5, 6])
      [ 1, 2, [ 3, 4, [5, 6] ] ].flatten(-10).should_equal([1, 2, 3, 4, 5, 6])
    end
    
    it.tries "to convert passed Objects to Integers using #to_int" do
      obj = mock("Converted to Integer")
      obj.should_receive(:to_int).and_return(1)
      
      [ 1, 2, [3, [4, 5] ] ].flatten(obj).should_equal([1, 2, 3, [4, 5]])
    end

    it.checks "wheter the passed argument responds to #to_int" do
      obj = mock('method_missing to_int')
      obj.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
      obj.should_receive(:method_missing).with(:to_int).and_return(1)
      [1, 2, [3, [4, 5] ] ].flatten(obj).should_equal([1, 2, 3, [4, 5]])
    end
    
    it.raises " a TypeError when the passed Object can't be converted to an Integer" do
      obj = mock("Not converted")
      obj.should_receive(:respond_to?).with(:to_int).and_return(false)
      lambda { [ 1, 2, [3, [4, 5] ] ].flatten(obj) }.should_raise(TypeError)
    end
  end

  it.does_not "call flatten on elements" do
    obj = mock('[1,2]')
    obj.should_not_receive(:flatten)
    [obj, obj].flatten.should_equal([obj, obj])

    obj = [5, 4]
    obj.should_not_receive(:flatten)
    [obj, obj].flatten.should_equal([5, 4, 5, 4])
  end
  
  it.raises " an ArgumentError on recursive arrays" do
    x = []
    x << x
    lambda { x.flatten }.should_raise(ArgumentError)
  
    x = []
    y = []
    x << y
    y << x
    lambda { x.flatten }.should_raise(ArgumentError)
  end

  it.can "flattens any element which responds to #to_ary, using the return value of said method" do
    x = mock("[3,4]")
    x.should_receive(:to_ary).at_least(:once).and_return([3, 4])
    [1, 2, x, 5].flatten.should_equal([1, 2, 3, 4, 5])

    y = mock("MyArray[]")
    y.should_receive(:to_ary).at_least(:once).and_return(ArraySpecs::MyArray[])
    [y].flatten.should_equal([])

    z = mock("[2,x,y,5]")
    z.should_receive(:to_ary).and_return([2, x, y, 5])
    [1, z, 6].flatten.should_equal([1, 2, 3, 4, 5, 6])
  end
  
  it.returns "subclass instance for Array subclasses" do
    ArraySpecs::MyArray[].flatten.class.should_equal(ArraySpecs::MyArray)
    ArraySpecs::MyArray[1, 2, 3].flatten.class.should_equal(ArraySpecs::MyArray)
    ArraySpecs::MyArray[1, [2], 3].flatten.class.should_equal(ArraySpecs::MyArray)
    [ArraySpecs::MyArray[1, 2, 3]].flatten.class.should_equal(Array)
  end

  it.is_not " destructive" do
    ary = [1, [2, 3]]
    ary.flatten
    ary.should_equal([1, [2, 3]])
  end
end  

describe "Array#flatten!" do |it| 
  it.will "modifyarray to produce a one-dimensional flattening recursively" do
    a = [[[1, [2, 3]],[2, 3, [4, [4, [5, 5]], [1, 2, 3]]], [4]], []]
    a.flatten!
    a.should_equal([1, 2, 3, 2, 3, 4, 4, 5, 5, 1, 2, 3, 4])
  end

  it.returns "self if made some modifications" do
    a = [[[1, [2, 3]],[2, 3, [4, [4, [5, 5]], [1, 2, 3]]], [4]], []]
    a.flatten!.should_equal(a)
  end

  it.returns "nil if no modifications took place" do
    a = [1, 2, 3]
    a.flatten!.should_equal(nil)
    a = [1, [2, 3]]
    a.flatten!.should_not == nil
  end

  ruby_version_is "1.8.7" do
    it.can "take an optional argument that determines the level of recursion" do
      [ 1, 2, [3, [4, 5] ] ].flatten!(1).should_equal([1, 2, 3, [4, 5]])
    end
    
    # NOTE: This is inconsistent behaviour, it should return nil
    it.returns "self when the level of recursion is 0" do
      a = [ 1, 2, [3, [4, 5] ] ]
      a.flatten!(0).should_equal(a)
    end
    
    it.will "ignore negative levels" do
      [ 1, 2, [ 3, 4, [5, 6] ] ].flatten!(-1).should_equal([1, 2, 3, 4, 5, 6])
      [ 1, 2, [ 3, 4, [5, 6] ] ].flatten!(-10).should_equal([1, 2, 3, 4, 5, 6])
    end
    
    it.tries "to convert passed Objects to Integers using #to_int" do
      obj = mock("Converted to Integer")
      obj.should_receive(:to_int).and_return(1)
      
      [ 1, 2, [3, [4, 5] ] ].flatten!(obj).should_equal([1, 2, 3, [4, 5]])
    end

    it.checks "wheter the passed argument responds to #to_int" do
      obj = mock('method_missing to_int')
      obj.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
      obj.should_receive(:method_missing).with(:to_int).and_return(1)
      [1, 2, [3, [4, 5] ] ].flatten!(obj).should_equal([1, 2, 3, [4, 5]])
    end
    
    it.raises " a TypeError when the passed Object can't be converted to an Integer" do
      obj = mock("Not converted")
      lambda { [ 1, 2, [3, [4, 5] ] ].flatten!(obj) }.should_raise(TypeError)
    end
  end

  it.does_not "call flatten! on elements" do
    obj = mock('[1,2]')
    obj.should_not_receive(:flatten!)
    [obj, obj].flatten!.should_equal(nil)

    obj = [5, 4]
    obj.should_not_receive(:flatten!)
    [obj, obj].flatten!.should_equal([5, 4, 5, 4])
  end

  it.raises " an ArgumentError on recursive arrays" do
    x = []
    x << x
    lambda { x.flatten! }.should_raise(ArgumentError)
  
    x = []
    y = []
    x << y
    y << x
    lambda { x.flatten! }.should_raise(ArgumentError)
  end

  it.can "flattens any elements which responds to #to_ary, using the return value of said method" do
    x = mock("[3,4]")
    x.should_receive(:to_ary).at_least(:once).and_return([3, 4])
    [1, 2, x, 5].flatten!.should_equal([1, 2, 3, 4, 5])

    y = mock("MyArray[]")
    y.should_receive(:to_ary).at_least(:once).and_return(ArraySpecs::MyArray[])
    [y].flatten!.should_equal([])

    z = mock("[2,x,y,5]")
    z.should_receive(:to_ary).and_return([2, x, y, 5])
    [1, z, 6].flatten!.should_equal([1, 2, 3, 4, 5, 6])

    ary = [ArraySpecs::MyArray[1, 2, 3]]
    ary.flatten!
    ary.class.should_equal(Array)
    ary.should_equal([1, 2, 3])
  end

  compliant_on :ruby, :jruby, :ir do
    ruby_version_is '' ... '1.9' do
      it.raises " a TypeError on frozen arrays when modification would take place" do
        nested_ary = [1, 2, []]
        nested_ary.freeze
        lambda { nested_ary.flatten! }.should_raise(TypeError)
      end
    end
    ruby_version_is '1.9' do
      it.raises " a RuntimeError on frozen arrays when modification would take place" do
        nested_ary = [1, 2, []]
        nested_ary.freeze
        lambda { nested_ary.flatten! }.should_raise(RuntimeError)
      end
    end

    it.does_not "raise on frozen arrays when no modification would take place" do
      ArraySpecs.frozen_array.flatten!.should_be_nil
    end
  end
end
