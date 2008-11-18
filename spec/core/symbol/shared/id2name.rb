describe :symbol_id2name, :shared => true do
  it.returns "the string corresponding to self" do
    :rubinius.send(@method).should_equal("rubinius")
    :squash.send(@method).should_equal("squash")
    :[].send(@method).should_equal("[]")
    :@ruby.send(@method).should_equal("@ruby")
    :@@ruby.send(@method).should_equal("@@ruby")
  end
end
