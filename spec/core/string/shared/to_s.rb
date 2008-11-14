describe :string_to_s, :shared => true do
  it.returns "self when self.class == String" do
    a = "a string"
    a.should_equal(a.send(@method))
  end

  it.returns "a new instance of String when called on a subclass" do
    a = StringSpecs::MyString.new("a string")
    s = a.send(@method)
    s.should_equal("a string")
    s.class.should_equal(String)
  end

  it.will "taint the result when self is tainted" do
    "x".taint.send(@method).tainted?.should_equal(true)
    StringSpecs::MyString.new("x").taint.send(@method).tainted?.should_equal(true)
  end
end
