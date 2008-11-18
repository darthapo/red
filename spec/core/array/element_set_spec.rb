# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Array#[]=" do |it| 
  it.will "set the value of the element at index" do
    a = [1, 2, 3, 4]
    a[2] = 5
    a[-1] = 6
    a[5] = 3
    a.should_equal([1, 2, 5, 6, nil, 3])

    a = []
    a[4] = "e"
    a.should_equal([nil, nil, nil, nil, "e"])
    a[3] = "d"
    a.should_equal([nil, nil, nil, "d", "e"])
    a[0] = "a"
    a.should_equal(["a", nil, nil, "d", "e"])
    a[-3] = "C"
    a.should_equal(["a", nil, "C", "d", "e"])
    a[-1] = "E"
    a.should_equal(["a", nil, "C", "d", "E"])
    a[-5] = "A"
    a.should_equal(["A", nil, "C", "d", "E"])
    a[5] = "f"
    a.should_equal(["A", nil, "C", "d", "E", "f"])
    a[1] = []
    a.should_equal(["A", [], "C", "d", "E", "f"])
    a[-1] = nil
    a.should_equal(["A", [], "C", "d", "E", nil])
  end
  
  it.will "set the section defined by [start,length] to other" do
    a = [1, 2, 3, 4, 5, 6]
    a[0, 1] = 2
    a[3, 2] = ['a', 'b', 'c', 'd']
    a.should_equal([2, 2, 3, "a", "b", "c", "d", 6])
  end
  it.will "replace the section defined by [start,length] with the given values" do
    a = [1, 2, 3, 4, 5, 6]
    a[3, 2] = 'a', 'b', 'c', 'd'
    a.should_equal([1, 2, 3, "a", "b", "c", "d", 6])
  end

  ruby_version_is '' ... '1.9' do
    it.can "removes the section defined by [start,length] when set to nil" do
      a = ['a', 'b', 'c', 'd', 'e']
      a[1, 3] = nil
      a.should_equal(["a", "e"])
    end
  end
  ruby_version_is '1.9' do
    it.can "just sets the section defined by [start,length] to other even if other is nil" do
      a = ['a', 'b', 'c', 'd', 'e']
      a[1, 3] = nil
      a.should_equal(["a", nil, "e"])
    end
  end
  it.returns "nil if the rhs is nil" do
    a = [1, 2, 3]
    (a[1, 3] = nil).should_equal(nil)
    (a[1..3] = nil).should_equal(nil)
  end
  
  it.will "set the section defined by range to other" do
    a = [6, 5, 4, 3, 2, 1]
    a[1...2] = 9
    a[3..6] = [6, 6, 6]
    a.should_equal([6, 9, 4, 6, 6, 6])
  end

  it.will "replace the section defined by range with the given values" do
    a = [6, 5, 4, 3, 2, 1]
    a[3..6] = :a, :b, :c
    a.should_equal([6, 5, 4, :a, :b, :c])
  end

  ruby_version_is '' ... '1.9' do
    it.can "removes the section defined by range when set to nil" do
      a = [1, 2, 3, 4, 5]
      a[0..1] = nil
      a.should_equal([3, 4, 5])
    end
    it.can "just sets the section defined by range to nil when the rhs is [nil]." do
      a = [1, 2, 3, 4, 5]
      a[0..1] = [nil]
      a.should_equal([nil, 3, 4, 5])
    end
  end
  ruby_version_is '1.9' do
    it.can "just sets the section defined by range to other even if other is nil" do
      a = [1, 2, 3, 4, 5]
      a[0..1] = nil
      a.should_equal([nil, 3, 4, 5])
    end
  end
  
  it.calls " to_int on its start and length arguments" do
    obj = mock('to_int')
    obj.stub!(:to_int).and_return(2)
      
    a = [1, 2, 3, 4]
    a[obj, 0] = [9]
    a.should_equal([1, 2, 9, 3, 4])
    a[obj, obj] = []
    a.should_equal([1, 2, 4])
    a[obj] = -1
    a.should_equal([1, 2, -1])
  end

  it.will "set elements in the range arguments when passed ranges" do
    ary = [1, 2, 3]
    rhs = [nil, [], ["x"], ["x", "y"]]
    (0 .. ary.size + 2).each do |a|
      (a .. ary.size + 3).each do |b|
        rhs.each do |c|
          ary1 = ary.dup
          ary1[a .. b] = c
          ary2 = ary.dup
          ary2[a, 1 + b-a] = c
          ary1.should_equal(ary2)
          
          ary1 = ary.dup
          ary1[a ... b] = c
          ary2 = ary.dup
          ary2[a, b-a] = c
          ary1.should_equal(ary2)
        end
      end
    end
  end

  it.can "inserts the given elements with [range] which the range is zero-width" do
    ary = [1, 2, 3]
    ary[1...1] = 0
    ary.should_equal([1, 0, 2, 3])
    ary[1...1] = [5]
    ary.should_equal([1, 5, 0, 2, 3])
    ary[1...1] = :a, :b, :c
    ary.should_equal([1, :a, :b, :c, 5, 0, 2, 3])
  end

  it.can "inserts the given elements with [start, length] which length is zero" do
    ary = [1, 2, 3]
    ary[1, 0] = 0
    ary.should_equal([1, 0, 2, 3])
    ary[1, 0] = [5]
    ary.should_equal([1, 5, 0, 2, 3])
    ary[1, 0] = :a, :b, :c
    ary.should_equal([1, :a, :b, :c, 5, 0, 2, 3])
  end

  # Now we only have to test cases where the start, length interface would
  # have raise an exception because of negative size
  it.can "inserts the given elements with [range] which the range has negative width" do
    ary = [1, 2, 3]
    ary[1..0] = 0
    ary.should_equal([1, 0, 2, 3])
    ary[1..0] = [4, 3]
    ary.should_equal([1, 4, 3, 0, 2, 3])
    ary[1..0] = :a, :b, :c
    ary.should_equal([1, :a, :b, :c, 4, 3, 0, 2, 3])
  end

  ruby_version_is '' ... '1.9' do
    it.does_not "hing if the section defined by range is zero-width and the rhs is nil" do
      ary = [1, 2, 3]
      ary[1...1] = nil
      ary.should_equal([1, 2, 3])
    end
    it.does_not "hing if the section defined by range has negative width and the rhs is nil" do
      ary = [1, 2, 3]
      ary[1..0] = nil
      ary.should_equal([1, 2, 3])
    end
  end
  ruby_version_is '1.9' do
    it.can "just inserts nil if the section defined by range is zero-width and the rhs is nil" do
      ary = [1, 2, 3]
      ary[1...1] = nil
      ary.should_equal([1, nil, 2, 3])
    end
    it.can "just inserts nil if the section defined by range has negative width and the rhs is nil" do
      ary = [1, 2, 3]
      ary[1..0] = nil
      ary.should_equal([1, nil, 2, 3])
    end
  end

  it.does_not "hing if the section defined by range is zero-width and the rhs is an empty array" do
    ary = [1, 2, 3]
    ary[1...1] = []
    ary.should_equal([1, 2, 3])
  end
  it.does_not "hing if the section defined by range has negative width and the rhs is an empty array" do
    ary = [1, 2, 3, 4, 5]
    ary[1...0] = []
    ary.should_equal([1, 2, 3, 4, 5])
    ary[-2..2] = []
    ary.should_equal([1, 2, 3, 4, 5])
  end

  it.tries "to convert Range elements to Integers using #to_int with [m..n] and [m...n]" do
    from = mock('from')
    to = mock('to')

    # So we can construct a range out of them...
    def from.<=>(o) 0 end
    def to.<=>(o) 0 end

    def from.to_int() 1 end
    def to.to_int() -2 end
      
    a = [1, 2, 3, 4]
      
    a[from .. to] = ["a", "b", "c"]
    a.should_equal([1, "a", "b", "c", 4])

    a[to .. from] = ["x"]
    a.should_equal([1, "a", "b", "x", "c", 4])
    lambda { a["a" .. "b"] = []  }.should_raise(TypeError)
    lambda { a[from .. "b"] = [] }.should_raise(TypeError)
  end

  it.checks "whether the Range elements respond to #to_int with [m..n] and [m...n]" do
    from = mock('from')
    to = mock('to')

    def from.<=>(o) 0 end
    def to.<=>(o) 0 end

    from.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    from.should_receive(:method_missing).with(:to_int).and_return(1)

    to.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    to.should_receive(:method_missing).with(:to_int).and_return(-2)

    [1, 2, 3, 4][from .. to] = ["a", "b", "c"]
  end

  it.raises " an IndexError when passed indexes out of bounds" do
    a = [1, 2, 3, 4]
    lambda { a[-5] = ""      }.should_raise(IndexError)
    lambda { a[-5, -1] = ""  }.should_raise(IndexError)
    lambda { a[-5, 0] = ""   }.should_raise(IndexError)
    lambda { a[-5, 1] = ""   }.should_raise(IndexError)
    lambda { a[-5, 2] = ""   }.should_raise(IndexError)
    lambda { a[-5, 10] = ""  }.should_raise(IndexError)
    
    lambda { a[-5..-5] = ""  }.should_raise(RangeError)
    lambda { a[-5...-5] = "" }.should_raise(RangeError)
    lambda { a[-5..-4] = ""  }.should_raise(RangeError)
    lambda { a[-5...-4] = "" }.should_raise(RangeError)
    lambda { a[-5..10] = ""  }.should_raise(RangeError)
    lambda { a[-5...10] = "" }.should_raise(RangeError)
    
    # ok
    a[0..-9] = [1]
    a.should_equal([1, 1, 2, 3, 4])
  end
  
  it.calls " to_ary on its rhs argument for multi-element sets" do
    obj = mock('to_ary')
    def obj.to_ary() [1, 2, 3] end
    ary = [1, 2]
    ary[0, 0] = obj
    ary.should_equal([1, 2, 3, 1, 2])
    ary[1, 10] = obj
    ary.should_equal([1, 1, 2, 3])
  end
  
  it.does_not "call to_ary on rhs array subclasses for multi-element sets" do
    ary = []
    ary[0, 0] = ArraySpecs::ToAryArray[5, 6, 7]
    ary.should_equal([5, 6, 7])
  end

  compliant_on :ruby, :jruby, :ir do


  end
end

describe "Array#[]= with [index]" do |it| 
  it.returns "value assigned if idx is inside array" do
    a = [1, 2, 3, 4, 5]
    (a[3] = 6).should_equal(6)
  end
  
  it.returns "value assigned if idx is right beyond right array boundary" do
    a = [1, 2, 3, 4, 5]
    (a[5] = 6).should_equal(6)
  end
  
  it.returns "value assigned if idx far beyond right array boundary" do
    a = [1, 2, 3, 4, 5]
    (a[10] = 6).should_equal(6)
  end

  it.will "set the value of the element at index" do
      a = [1, 2, 3, 4]
      a[2] = 5
      a[-1] = 6
      a[5] = 3
      a.should_equal([1, 2, 5, 6, nil, 3])
    end

  it.will "set the value of the element if it is right beyond the array boundary" do
    a = [1, 2, 3, 4]
    a[4] = 8
    a.should_equal([1, 2, 3, 4, 8])
  end
    
end

describe "Array#[]= with [index, count]" do |it| 
  it.returns "non-array value if non-array value assigned" do
    a = [1, 2, 3, 4, 5]
    (a[2, 3] = 10).should_equal(10)
  end

  it.returns "array if array assigned" do
    a = [1, 2, 3, 4, 5]
    (a[2, 3] = [4, 5]).should_equal([4, 5])
  end

  ruby_version_is '' ... '1.9' do
    it.can "removes the section defined by [start,length] when set to nil" do
      a = ['a', 'b', 'c', 'd', 'e']
      a[1, 3] = nil
      a.should_equal(["a", "e"])
    end
  end
  ruby_version_is '1.9' do
    it.can "just sets the section defined by [start,length] to nil even if the rhs is nil" do
      a = ['a', 'b', 'c', 'd', 'e']
      a[1, 3] = nil
      a.should_equal(["a", nil, "e"])
    end
  end
    
  ruby_version_is '' ... '1.9' do
    it.can "removes the section when set to nil if negative index within bounds and cnt > 0" do
      a = ['a', 'b', 'c', 'd', 'e']
      a[-3, 2] = nil
      a.should_equal(["a", "b", "e"])
    end
  end
  ruby_version_is '1.9' do
    it.can "just sets the section defined by [start,length] to nil if negative index within bounds, cnt > 0 and the rhs is nil" do
      a = ['a', 'b', 'c', 'd', 'e']
      a[-3, 2] = nil
      a.should_equal(["a", "b", nil, "e"])
    end
  end
  
  it.will "replace the section defined by [start,length] to other" do
      a = [1, 2, 3, 4, 5, 6]
      a[0, 1] = 2
      a[3, 2] = ['a', 'b', 'c', 'd']
      a.should_equal([2, 2, 3, "a", "b", "c", "d", 6])
    end

  it.will "replace the section to other if idx < 0 and cnt > 0" do
    a = [1, 2, 3, 4, 5, 6]
    a[-3, 2] = ["x", "y", "z"]
    a.should_equal([1, 2, 3, "x", "y", "z", 6])
  end

  it.will "replace the section to other even if cnt spanning beyond the array boundary" do
    a = [1, 2, 3, 4, 5]
    a[-1, 3] = [7, 8]
    a.should_equal([1, 2, 3, 4, 7, 8])
  end

  it.can "pads the Array with nils if the span is past the end" do
    a = [1, 2, 3, 4, 5]
    a[10, 1] = [1]
    a.should_equal([1, 2, 3, 4, 5, nil, nil, nil, nil, nil, 1])

    b = [1, 2, 3, 4, 5]
    b[10, 0] = [1]
    a.should_equal([1, 2, 3, 4, 5, nil, nil, nil, nil, nil, 1])
  end

  it.can "inserts other section in place defined by idx" do
    a = [1, 2, 3, 4, 5]
    a[3, 0] = [7, 8]
    a.should_equal([1, 2, 3, 7, 8, 4, 5])

    b = [1, 2, 3, 4, 5]
    b[1, 0] = b
    b.should_equal([1, 1, 2, 3, 4, 5, 2, 3, 4, 5])
  end
  
  it.raises " an IndexError when passed start and negative length" do
    a = [1, 2, 3, 4]
    lambda { a[-2, -1] = "" }.should_raise(IndexError)
    lambda { a[0, -1] = ""  }.should_raise(IndexError)
    lambda { a[2, -1] = ""  }.should_raise(IndexError)
    lambda { a[4, -1] = ""  }.should_raise(IndexError)
    lambda { a[10, -1] = "" }.should_raise(IndexError)
    lambda { [1, 2, 3, 4,  5][2, -1] = [7, 8] }.should_raise(IndexError)
  end
end

describe "Array#[]= with [m..n]" do |it| 
  it.returns "non-array value if non-array value assigned" do
    a = [1, 2, 3, 4, 5]
    (a[2..4] = 10).should_equal(10)
  end
  
  it.returns "array if array assigned" do
    a = [1, 2, 3, 4, 5]
    (a[2..4] = [7, 8]).should_equal([7, 8])
  end
  
  ruby_version_is '' ... '1.9' do
    it.can "removes the section defined by range when set to nil" do
      a = [1, 2, 3, 4, 5]
      a[0..1] = nil
      a.should_equal([3, 4, 5])
    end
    it.can "removes the section when set to nil if m and n < 0" do
      a = [1, 2, 3, 4, 5]
      a[-3..-2] = nil
      a.should_equal([1, 2, 5])
    end
  end
  ruby_version_is '1.9' do
    it.can "just sets the section defined by range to nil even if the rhs is nil" do
      a = [1, 2, 3, 4, 5]
      a[0..1] = nil
      a.should_equal([nil, 3, 4, 5])
    end
    it.can "just sets the section defined by range to nil if m and n < 0 and the rhs is nil" do
      a = [1, 2, 3, 4, 5]
      a[-3..-2] = nil
      a.should_equal([1, 2, nil, 5])
    end
  end

  it.will "replace the section defined by range" do
      a = [6, 5, 4, 3, 2, 1]
      a[1...2] = 9
      a[3..6] = [6, 6, 6]
      a.should_equal([6, 9, 4, 6, 6, 6])
    end

  it.will "replace the section if m and n < 0" do
    a = [1, 2, 3, 4, 5]
    a[-3..-2] = [7, 8, 9]
    a.should_equal([1, 2, 7, 8, 9, 5])
  end

  it.will "replace the section if m < 0 and n > 0" do
    a = [1, 2, 3, 4, 5]
    a[-4..3] = [8]
    a.should_equal([1, 8, 5])
  end

  it.can "inserts the other section at m if m > n" do
    a = [1, 2, 3, 4, 5]
    a[3..1] = [8]
    a.should_equal([1, 2, 3, 8, 4, 5])
  end
  
  it.will "accept Range subclasses" do
    a = [1, 2, 3, 4]
    range_incl = ArraySpecs::MyRange.new(1, 2)
    range_excl = ArraySpecs::MyRange.new(-3, -1, true)

    a[range_incl] = ["a", "b"]
    a.should_equal([1, "a", "b", 4])
    a[range_excl] = ["A", "B"]
    a.should_equal([1, "A", "B", 4])
  end
end

describe "Array#[] after a shift" do |it| 
  it.can "works for insertion" do
    a = [1,2]
    a.shift
    a.shift
    a[0,0] = [3,4]
    a.should_equal([3,4])
  end
end

