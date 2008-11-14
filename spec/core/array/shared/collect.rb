describe :array_collect, :shared => true do
  it.returns "a copy of array with each element replaced by the value returned by block" do
    a = ['a', 'b', 'c', 'd']
    b = a.send(@method) { |i| i + '!' }
    b.should_equal(["a!", "b!", "c!", "d!"])
    b.object_id.should_not == a.object_id
  end

  it.does_not "return subclass instance" do
    ArraySpecs::MyArray[1, 2, 3].send(@method) { |x| x + 1 }.class.should_equal(Array)
  end

  it.does_not "change self" do
    a = ['a', 'b', 'c', 'd']
    b = a.send(@method) { |i| i + '!' }
    a.should_equal(['a', 'b', 'c', 'd'])
  end

  it.returns "the evaluated value of block if it broke in the block" do
    a = ['a', 'b', 'c', 'd']
    b = a.send(@method) {|i|
      if i == 'c'
        break 0
      else
        i + '!'
      end
    }
    b.should_equal(0)
  end
  
  it.does_not "copy tainted status" do
    a = [1, 2, 3]
    a.taint
    a.send(@method){|x| x}.tainted?.should_be_false
  end
end

describe :array_collect_b, :shared => true do
  it.will "replace each element with the value returned by block" do
    a = [7, 9, 3, 5]
    a.send(@method) { |i| i - 1 }.should_equal(a)
    a.should_equal([6, 8, 2, 4])
  end

  it.returns "self" do
    a = [1, 2, 3, 4, 5]
    b = a.send(@method) {|i| i+1 }
    a.object_id.should_equal(b.object_id)
  end

  it.returns "the evaluated value of block but its contents is partially modified, if it broke in the block" do
    a = ['a', 'b', 'c', 'd']
    b = a.send(@method) {|i|
      if i == 'c'
        break 0
      else
        i + '!'
      end
    }
    b.should_equal(0)
    a.should_equal(['a!', 'b!', 'c', 'd'])
  end

  ruby_version_is '' ... '1.8.7' do
    it 'raises LocalJumpError if no block given' do
      a = [1, 2, 3]
      lambda { a.send(@method) }.should_raise(LocalJumpError, /no block given/)
    end
  end
  ruby_version_is '1.8.7' ... '1.9' do
    it.returns "an Enumerable::Enumerator when no block given, and the enumerator can modify the original array" do
      a = [1, 2, 3]
      enum = a.send(@method)
      enum.should_be_kind_of(Enumerable::Enumerator)
      enum.each{|i| "#{i}!" }
      a.should_equal(["1!", "2!", "3!"])
    end
  end
  ruby_version_is '1.9' do
    it.returns "an Enumerator when no block given, and the enumeratoe can modify the original array" do
      a = [1, 2, 3]
      enum = a.send(@method)
      enum.should_be_kind_of(Enumerator)
      enum.each{|i| "#{i}!" }
      a.should_equal(["1!", "2!", "3!"])
    end
  end

  it.will "keep tainted status" do
    a = [1, 2, 3]
    a.taint
    a.tainted?.should_be_true
    a.send(@method){|x| x}
    a.tainted?.should_be_true
  end

  ruby_version_is '1.9' do
    it.will "keep untrusted status" do
      a = [1, 2, 3]
      a.untrust
      a.send(@method){|x| x}
      a.untrusted?.should_be_true
    end
  end

  compliant_on :ruby, :jruby, :ir do


end
