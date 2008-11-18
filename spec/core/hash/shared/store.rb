describe :hash_store, :shared => true do
  it.can "associate the key with the value and return the value" do
    h = { :a => 1 }
    h.send(@method, :b, 2).should_equal(2)
    h.should_equal({:b=>2, :a=>1})
  end

  it.can "duplicate string keys using dup semantics" do
    # dup doesn't copy singleton methods
    key = "foo"
    def key.reverse() "bar" end
    h = {}
    h.send(@method, key, 0)
    h.keys[0].reverse.should_equal("oof")
  end

  it.can "store unequal keys that hash to the same value" do
    h = {}
    k1 = ["x"]
    k2 = ["y"]
    # So they end up in the same bucket
    def k1.hash() 0 end
    def k2.hash() 0 end

    h[k1] = 1
    h[k2] = 2
    h.size.should_equal(2)
  end
end
