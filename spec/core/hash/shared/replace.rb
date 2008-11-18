describe :hash_replace, :shared => true do
  it.will "replace the contents of self with other" do
    h = { :a => 1, :b => 2 }
    h.send(@method, :c => -1, :d => -2).should_equal(h)
    h.should_equal({ :c => -1, :d => -2 })
  end

  it.tries "to convert the passed argument to a hash using #to_hash" do
    obj = mock('{1=>2,3=>4}')
    obj.should_receive(:to_hash).and_return({1 => 2, 3 => 4})

    h = {}
    h.send(@method, obj)
    h.should_equal({1 => 2, 3 => 4})
  end

  it.checks "whether the passed argument responds to #to_hash" do
    obj = mock('{1=>2,3=>4}')
    obj.should_receive(:respond_to?).with(:to_hash).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_hash).and_return({1 => 2, 3 => 4})

    h = {}
    h.send(@method, obj)
    h.should_equal({1 => 2, 3 => 4})
  end

  it.calls " to_hash on hash subclasses" do
    h = {}
    h.send(@method, ToHashHash[1 => 2])
    h.should_equal({1 => 2})
  end

  it.does_not "transfer default values" do
    hash_a = {}
    hash_b = Hash.new(5)
    hash_a.send(@method, hash_b)
    hash_a.default.should_equal(5)

    hash_a = {}
    hash_b = Hash.new { |h, k| k * 2 }
    hash_a.send(@method, hash_b)
    hash_a.default(5).should_equal(10)

    hash_a = Hash.new { |h, k| k * 5 }
    hash_b = Hash.new(lambda { raise "Should not invoke lambda" })
    hash_a.send(@method, hash_b)
    hash_a.default.should_equal(hash_b.default)
  end
end
