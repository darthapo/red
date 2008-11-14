describe "Array#at" do |it|
  it.returns "the (n+1)'th element for the passed index n" do
    a = [1, 2, 3, 4, 5, 6]
    a.at(0).should_equal(1)
    a.at(1).should_equal(2)
    a.at(5).should_equal(6)
  end
  
  it.returns "nil if the given index is greater than or equal to the array's length" do
    a = [1, 2, 3, 4, 5, 6]
    a.at(6).should_equal(nil)
    a.at(7).should_equal(nil)
  end
  
  it.returns "the (-n)'th elemet from the last, for the given negative index n" do
    a = [1, 2, 3, 4, 5, 6]
    a.at(-1).should_equal(6)
    a.at(-2).should_equal(5)
    a.at(-6).should_equal(1)
  end
  
  it.returns "nil if the given index is less than -len, where len is length of the array"  do
    a = [1, 2, 3, 4, 5, 6]
    a.at(-7).should_equal(nil)
    a.at(-8).should_equal(nil)
  end
  
  it.does_not "extend the array unless the given index is out of range" do
    a = [1, 2, 3, 4, 5, 6]
    a.length.should_equal(6)
    a.at(100)
    a.length.should_equal(6)
    a.at(-100)
    a.length.should_equal(6)
  end
  
  it.can "try to convert the passed argument to an Integer using #to_int" do
    a = ["a", "b", "c"]
    a.at(0.5).should_equal("a")
  
    obj = mock('to_int')
    obj.should_receive(:to_int).and_return(2)
    a.at(obj).should_equal("c")
  end
  
  it.can "check whether the passed argument responds to #to_int" do
    obj = mock('method_missing to_int')
    obj.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_int).and_return(2)
    ["a", "b", "c"].at(obj).should_equal("c")
  end
  
  it.raises "a TypeError when the passed argument can't be coerced to Integer" do
    lambda { [].at("cat") }.should_raise(TypeError)
  end
  
  it.raises "an ArgumentError when 2 or more arguments is passed" do
    lambda { [:a, :b].at(0,1) }.should_raise(ArgumentError)
  end
end
