
describe "Object#metaclass" do |it| 
  it.returns "the object's metaclass" do
    foo = "foo"
    foo.instance_eval "class << self; def meta_test_method; 5; end; end"
    foo.respond_to?(:meta_test_method).should_equal(true)
    lambda { "hello".metaclass.method(:meta_test_method) }.should_raise(NameError)
  end
end
