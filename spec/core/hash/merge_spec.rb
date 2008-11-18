# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'
# require File.dirname(__FILE__) + '/shared/iteration'
# require File.dirname(__FILE__) + '/shared/update'

describe "Hash#merge" do |it| 
  it.returns "a new hash by combining self with the contents of other" do
    { 1 => :a, 2 => :b, 3 => :c }.merge(:a => 1, :c => 2).should_equal({ :c => 2, 1 => :a, 2 => :b, :a => 1, 3 => :c })
  end
  
  it.will "set any duplicate key to the value of block if passed a block" do
    h1 = { :a => 2, :b => 1, :d => 5}
    h2 = { :a => -2, :b => 4, :c => -3 }
    r = h1.merge(h2) { |k,x,y| nil }
    r.should_equal({ :a => nil, :b => nil, :c => -3, :d => 5 })
      
    r = h1.merge(h2) { |k,x,y| "#{k}:#{x+2*y}" }
    r.should_equal({ :a => "a:-2", :b => "b:9", :c => -3, :d => 5 })

    lambda {
      h1.merge(h2) { |k, x, y| raise(IndexError) }
    }.should_raise(IndexError)

    r = h1.merge(h1) { |k,x,y| :x }
    r.should_equal({ :a => :x, :b => :x, :d => :x })
  end

  it.tries "to convert the passed argument to a hash using #to_hash" do
    obj = mock('{1=>2}')
    obj.should_receive(:to_hash).and_return({1 => 2})
    {3 => 4}.merge(obj).should_equal({1 => 2, 3 => 4})
  end

  it.checks "whether the passed argument responds to #to_hash" do
    obj = mock('{1=>2}')
    obj.should_receive(:respond_to?).with(:to_hash).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_hash).and_return({ 1 => 2})
    {3 => 4}.merge(obj).should_equal({1 => 2, 3 => 4})
  end

  it.does_not "call to_hash on hash subclasses" do    
    {3 => 4}.merge(ToHashHash[1 => 2]).should_equal({1 => 2, 3 => 4})
  end

  it.returns "subclass instance for subclasses" do
    MyHash[1 => 2, 3 => 4].merge({1 => 2}).class.should_equal(MyHash)
    MyHash[].merge({1 => 2}).class.should_equal(MyHash)

    {1 => 2, 3 => 4}.merge(MyHash[1 => 2]).class.should_equal(Hash)
    {}.merge(MyHash[1 => 2]).class.should_equal(Hash)
  end
  
  it.can "processes entries with same order as each()" do
    h = {1 => 2, 3 => 4, 5 => 6, "x" => nil, nil => 5, [] => []}
    merge_pairs = []
    each_pairs = []
    h.each_pair { |*pair| each_pairs << pair }
    h.merge(h) { |k, v1, v2| merge_pairs << [k, v1] }
    merge_pairs.should_equal(each_pairs)
  end

  it.behaves_like(:hash_iteration_method, :merge)
  it.behaves_like(:hash_iteration_modifying, :merge)
end

describe "Hash#merge!" do |it| 
  it.behaves_like(:hash_update, :merge!)

  it.behaves_like(:hash_iteration_method, :merge!)

  compliant_on :ruby, :rubinius do
    it.behaves_like(:hash_iteration_modifying, :merge!)
  end
end
