describe :module_class_eval, :shared => true do
  it.can "evaluates a given string in the context of self" do
    ModuleSpecs.send(@method, "self").should_equal(ModuleSpecs)
    ModuleSpecs.send(@method, "1 + 1").should_equal(2)
  end

  it.does_not "add defined methods to other classes" do
    FalseClass.class_eval do
      def foo
        'foo'
      end
    end
    lambda {42.foo}.should_raise(NoMethodError)
  end

  it.can "define constants in the receiver's scope" do
    ModuleSpecs.send(@method, "module NewEvaluatedModule;end")
    ModuleSpecs.const_defined?(:NewEvaluatedModule).should_equal(true)
  end
  
  it.can "evaluate a given block in the context of self" do
    ModuleSpecs.send(@method) { self }.should_equal(ModuleSpecs)
    ModuleSpecs.send(@method) { 1 + 1 }.should_equal(2)
  end
  
  it.can "use the optional filename and lineno parameters for error messages" do
    ModuleSpecs.send(@method, "[__FILE__, __LINE__]", "test", 102).should_equal(["test", 102])
  end

  it.can "convert non string eval-string to string using to_str" do
    (o = mock('1 + 1')).should_receive(:to_str).and_return("1 + 1")
    ModuleSpecs.send(@method, o).should_equal(2)
  end

  it.raises " a TypeError when the given eval-string can't be converted to string using to_str" do
    o = mock('x')
    lambda { ModuleSpecs.send(@method, o) }.should_raise(TypeError)
  
    (o = mock('123')).should_receive(:to_str).and_return(123)
    lambda { ModuleSpecs.send(@method, o) }.should_raise(TypeError)
  end

  it.raises " an ArgumentError when no arguments and no block are given" do
    lambda { ModuleSpecs.send(@method) }.should_raise(ArgumentError)
  end

  it.raises " an ArgumentError when more than 3 arguments are given" do
    lambda {
      ModuleSpecs.send(@method, "1 + 1", "some file", 0, "bogus")
    }.should_raise(ArgumentError)
  end

  it.raises " an ArgumentError when a block and normal arguments are given" do
    lambda {
      ModuleSpecs.send(@method, "1 + 1") { 1 + 1 }
    }.should_raise(ArgumentError)
  end
end
