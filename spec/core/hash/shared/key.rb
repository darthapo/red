describe :hash_key_p, :shared => true do
  it.returns "true if argument is a key" do
    h = { :a => 1, :b => 2, :c => 3, 4 => 0 }
    h.send(@method, :a).should_equal(true)
    h.send(@method, :b).should_equal(true)
    h.send(@method, 'b').should_equal(false)
    h.send(@method, 2).should_equal(false)
    h.send(@method, 4).should_equal(true)
    h.send(@method, 4.0).should_equal(false)
  end

  it.returns "true if the key's matching value was nil" do
    { :xyz => nil }.send(@method, :xyz).should_equal(true)
  end

  it.returns "true if the key's matching value was false" do
    { :xyz => false }.send(@method, :xyz).should_equal(true)
  end

  it.returns "true if the key is nil" do
    { nil => 'b'}.send(@method, nil).should_equal(true)
    { nil => nil}.send(@method, nil).should_equal(true)
  end

  it.returns "false for objects with the same hash" do
    o1 = Object.new
    def o1.hash() 0 end

    o2 = Object.new
    def o2.hash() 0 end

    { o1 => nil }.send(@method, o2).should_equal(false)
  end
end
