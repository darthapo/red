# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Hash#invert" do |it| 
  it.returns "a new hash where keys are values and vice versa" do
    { 1 => 'a', 2 => 'b', 3 => 'c' }.invert.should_equal({ 'a' => 1, 'b' => 2, 'c' => 3 })
  end
  
  it.can "handle collisions by overriding with the key coming later in keys()" do
    h = { :a => 1, :b => 1 }
    override_key = h.keys.last
    h.invert[1].should_equal(override_key)
  end

  it.can "compare new keys with eql? semantics" do
    h = { :a => 1.0, :b => 1 }
    i = h.invert
    i[1.0].should_equal(:a)
    i[1].should_equal(:b)
  end
  
  it.does_not "return subclass instances for subclasses" do
    MyHash[1 => 2, 3 => 4].invert.class.should_equal(Hash)
    MyHash[].invert.class.should_equal(Hash)
  end
end
