describe "Array#clear" do |it| 
  it.can "remove all elements" do
    a = [1, 2, 3, 4]
    a.clear.should_equal(a)
    a.should_equal([])  
  end  

  it.returns "self" do
    a = [1]
    oid = a.object_id
    a.clear.object_id.should_equal(oid)  
  end

  it.will "leave the Array empty" do
    a = [1]
    a.clear
    a.empty?.should_equal(true)    
    a.size.should_equal(0)  
  end

  it.can "keep its tainted status" do
    a = [1]
    a.taint
    a.tainted?.should_be_true
    a.clear
    a.tainted?.should_be_true
  end
end
