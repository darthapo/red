describe :string_equal_value, :shared => true do
  it.returns "true if self <=> string returns 0" do
    'hello'.send(@method, 'hello').should_equal(true)
  end

  it.returns "false if self <=> string does not return 0" do
    "more".send(@method, "MORE").should_equal(false)
    "less".send(@method, "greater").should_equal(false)
  end

  it.will "ignore subclass differences" do
    a = "hello"
    b = StringSpecs::MyString.new("hello")

    a.send(@method, b).should_equal(true)
    b.send(@method, a).should_equal(true)
  end
end
