describe :string_concat, :shared => true do
  it.will "concatenate the given argument to self and returns self" do
    str = 'hello '
    str.send(@method, 'world').should_equal(str)
    str.should_equal("hello world")
  end
  
  it.can "convert the given argument to a String using to_str" do
    obj = mock('world!')
    obj.should_receive(:to_str).and_return("world!")
    a = 'hello '.send(@method, obj)
    a.should_equal('hello world!')
    
    obj = mock('world!')
    obj.should_receive(:respond_to?).with(:to_str).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_str).and_return("world!")
    a = 'hello '.send(@method, obj)
    a.should_equal('hello world!')
  end
  
  it.raises " a TypeError if the given argument can't be converted to a String" do
    lambda { a = 'hello '.send(@method, :world)    }.should_raise(TypeError)
    lambda { a = 'hello '.send(@method, mock('x')) }.should_raise(TypeError)
  end
  
  it.can "works when given a subclass instance" do
    a = "hello"
    a << StringSpecs::MyString.new(" world")
    a.should_equal("hello world")
  end
  
  it.will "taint self if other is tainted" do
    x = "x"
    x.send(@method, "".taint).tainted?.should_equal(true)

    x = "x"
    x.send(@method, "y".taint).tainted?.should_equal(true)
  end
end

describe :string_concat_fixnum, :shared => true do
  it.can "convert the given Fixnum to a char before concatenating" do
    b = 'hello '.send(@method, 'world').send(@method, 33)
    b.should_equal("hello world!")
    b.send(@method, 0)
    b.should_equal("hello world!\x00")
  end

  it.raises " a TypeError when the given Fixnum is not between 0 and 255" do
    lambda { "hello world".send(@method, 333) }.should_raise(TypeError)
    lambda { "".send(@method, (256 * 3 + 64)) }.should_raise(TypeError)
    lambda { "".send(@method, -200)           }.should_raise(TypeError)
  end

  it.does_not " call to_int on its argument" do
    x = mock('x')
    x.should_not_receive(:to_int)
    
    lambda { "".send(@method, x) }.should_raise(TypeError)
  end
end
