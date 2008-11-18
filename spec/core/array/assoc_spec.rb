describe "Array#assoc" do |it|
  it.returns "the first array whose 1st item is == obj or nil" do
    s1 = ["colors", "red", "blue", "green"] 
    s2 = [:letters, "a", "b", "c"]
    s3 = [4]
    s4 = ["colors", "cyan", "yellow", "magenda"]
    s5 = [:letters, "a", "i", "u"]
    s_nil = [nil, nil]
    a = [s1, s2, s3, s4, s5, s_nil]
    a.assoc(s1.first).should_equal(s1)
    a.assoc(s2.first).should_equal(s2)
    a.assoc(s3.first).should_equal(s3)
    a.assoc(s4.first).should_equal(s1)
    a.assoc(s5.first).should_equal(s2)
    a.assoc(s_nil.first).should_equal(s_nil)
    a.assoc(4).should_equal(s3)
    a.assoc("key not in array").should_be_nil
  end

  it.can "call == on first element of each array" do
    key1 = 'it'
    key2 = mock('key2')
    items = [['not it', 1], [ArraySpecs::AssocKey.new, 2], ['na', 3]]

    items.assoc(key1).should_equal(items[1])
    items.assoc(key2).should_be_nil
  end
  
  it.will "ignore any non-Array elements" do
    [1, 2, 3].assoc(2).should_be_nil
    s1 = [4]
    s2 = [5, 4, 3]
    a = ["foo", [], s1, s2, nil, []] 
    a.assoc(s1.first).should_equal(s1)
    a.assoc(s2.first).should_equal(s2)
  end
end
