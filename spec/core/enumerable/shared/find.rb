describe :enumerable_find, :shared => true do
  # #detect and #find are aliases, so we only need one function 
  before :each do
    @elements = [2, 4, 6, 8, 10]
    @numerous = EnumerableSpecs::Numerous.new(*@elements)
  end
  
  it.will "passe each entry in enum to block while block when block is false" do
    visited_elements = []
    @numerous.send(@method) do |element|
      visited_elements << element
      false
    end
    visited_elements.should_equal(@elements)
  end
  
  it.returns "nil when the block is false and there is no ifnone proc given" do
    @numerous.send(@method) {|e| false }.should_equal(nil)
  end
  
  it.returns "the first element for which the block is not false" do
    @elements.each do |element|
      @numerous.send(@method) {|e| e > element - 1 }.should_equal(element)
    end
  end
  
  it.returns "the value of the ifnone proc if the block is false" do
    fail_proc = lambda { "cheeseburgers" }
    @numerous.send(@method, fail_proc) {|e| false }.should_equal("cheeseburgers")
  end
  
  it.does_not " call the ifnone proc if an element is found" do
    fail_proc = lambda { raise "This shouldn't have been called" }
    @numerous.send(@method, fail_proc) {|e| e == @elements.first }.should_equal(2)
  end
  
  it.calls " the ifnone proc only once when the block is false" do
    times = 0
    fail_proc = lambda { times += 1; raise if times > 1; "cheeseburgers" }
    @numerous.send(@method, fail_proc) {|e| false }.should_equal("cheeseburgers")
  end
end
