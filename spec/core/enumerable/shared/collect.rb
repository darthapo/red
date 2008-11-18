describe :enumerable_collect, :shared => true do
  it.can "collect should return a new array with the results of passing each element to block" do
    entries = [0, 1, 3, 4, 5, 6]
    numerous = EnumerableSpecs::Numerous.new(*entries)
    numerous.send(@method) { |i| i % 2 }.should_equal([0, 1, 1, 0, 1, 0])
    numerous.send(@method) { |i| i }.should_equal(entries)
  end 
end
