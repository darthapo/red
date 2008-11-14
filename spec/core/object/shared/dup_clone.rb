class ObjectSpecDup
  def initialize()
    @obj = :original
  end

  attr_accessor :obj
end

class ObjectSpecDupInitCopy
  def initialize()
    @obj = :original
  end

  attr_accessor :obj, :original

  def initialize_copy(original)
    @obj = :init_copy
    @original = original
  end

  private :initialize_copy
end

describe :object_dup_clone, :shared => true do
  it.returns "a new object duplicated from the original" do
    o = ObjectSpecDup.new
    o2 = ObjectSpecDup.new

    o.obj = 10

    o3 = o.send(@method)

    o3.obj.should_equal(10)
    o2.obj.should_equal(:original)
  end

  it.will "produce a shallow copy, contained objects are not recursively dupped" do
    o = ObjectSpecDup.new
    array = [1, 2]
    o.obj = array

    o2 = o.send(@method)
    o2.obj.should_equal(o.obj)
  end

  it.calls " #initialize_copy on the NEW object if available, passing in original object" do
    o = ObjectSpecDupInitCopy.new
    o2 = o.send(@method)

    o.obj.should_equal(:original)
    o2.obj.should_equal(:init_copy)
    o2.original.should_equal(o)
  end
end
