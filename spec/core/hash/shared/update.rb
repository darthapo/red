describe :hash_update, :shared => true do
  it.will "add the entries from other, overwriting duplicate keys. Returns self" do
    h = { :_1 => 'a', :_2 => '3' }
    h.send(@method, :_1 => '9', :_9 => 2).should_equal(h)
    h.should_equal({:_1 => "9", :_2 => "3", :_9 => 2})
  end

  it.will "set any duplicate key to the value of block if passed a block" do
    h1 = { :a => 2, :b => -1 }
    h2 = { :a => -2, :c => 1 }
    h1.send(@method, h2) { |k,x,y| 3.14 }.should_equal(h1)
    h1.should_equal({:c => 1, :b => -1, :a => 3.14})

    h1.send(@method, h1) { nil }
    h1.should_equal({ :a => nil, :b => nil, :c => nil })
  end

  it.tries "to convert the passed argument to a hash using #to_hash" do
    obj = mock('{1=>2}')
    obj.should_receive(:to_hash).and_return({1 => 2})
    {3 => 4}.send(@method, obj).should_equal({1 => 2, 3 => 4})
  end

  it.checks "whether the passed argument responds to #to_hash" do
    obj = mock('{1=>2}')
    obj.should_receive(:respond_to?).with(:to_hash).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_hash).and_return({ 1 => 2})
    {3 => 4}.send(@method, obj).should_equal({1 => 2, 3 => 4})
  end

  it.does_not "call to_hash on hash subclasses" do    
    {3 => 4}.send(@method, ToHashHash[1 => 2]).should_equal({1 => 2, 3 => 4})
  end

  it.can "process entries with same order as merge()" do
    h = {1 => 2, 3 => 4, 5 => 6, "x" => nil, nil => 5, [] => []}
    merge_bang_pairs = []
    merge_pairs = []
    h.merge(h) { |*arg| merge_pairs << arg }
    h.send(@method, h) { |*arg| merge_bang_pairs << arg }
    merge_bang_pairs.should_equal(merge_pairs)
  end
end
