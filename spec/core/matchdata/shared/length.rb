describe :matchdata_length, :shared => true do
  it.should "return the number of elements in the match array" do
    /(.)(.)(\d+)(\d)/.match("THX1138.").send(@method).should_equal(5)
  end
end
