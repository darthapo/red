describe "NilClass#dup" do |it| 
  it.raises " a TypeError" do
    lambda { nil.dup }.should_raise(TypeError)
  end
end
