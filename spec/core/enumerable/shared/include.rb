describe :enumerable_include, :shared => true do
  it.returns "true if any element == argument" do
    class EnumerableSpecIncludeP; def ==(obj) obj == 5; end; end

    elements = (0..5).to_a
    EnumerableSpecs::Numerous.new(*elements).send(@method,5).should_equal(true )
    EnumerableSpecs::Numerous.new(*elements).send(@method,10).should_equal(false)
    EnumerableSpecs::Numerous.new(*elements).send(@method,EnumerableSpecIncludeP.new).should_equal(true)
  end
  
  it.returns "true if any member of enum equals obj when == compare different classes (legacy rubycon)" do
    # equality is tested with ==
    EnumerableSpecs::Numerous.new(2,4,6,8,10).send(@method, 2.0).should_equal(true)
    EnumerableSpecs::Numerous.new(2,4,[6,8],10).send(@method, [6, 8]).should_equal(true)
    EnumerableSpecs::Numerous.new(2,4,[6,8],10).send(@method, [6.0, 8.0]).should_equal(true)
  end
end
