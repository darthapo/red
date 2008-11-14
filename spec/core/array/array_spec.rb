describe "Array" do |it|
  it.will "include Enumerable" do
    Array.ancestors.include?(Enumerable).should_equal(true)
  end
end
