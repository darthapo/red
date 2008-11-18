describe :string_to_sym, :shared => true do
  it.returns "the symbol corresponding to self" do
    "Koala".send(@method).should_equal(:Koala)
    'cat'.send(@method).should_equal(:cat)
    '@cat'.send(@method).should_equal(:@cat)
    'cat and dog'.send(@method).should_equal(:"cat and dog")
    "abc=".send(@method).should_equal(:abc=)
  end

  it.raises " an ArgumentError when self can't be converted to symbol" do
    lambda { "".send(@method)           }.should_raise(ArgumentError)
    lambda { "foo\x00bar".send(@method) }.should_raise(ArgumentError)
  end
end
