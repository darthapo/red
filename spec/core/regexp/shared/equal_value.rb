describe :regexp_eql, :shared => true do
  it.is "true if self and other have the same pattern" do
    /abc/.send(@method, /abc/).should_equal(true)
    /abc/.send(@method, /abd/).should_equal(false)
  end

  it.is "true if self and other have the same character set code" do
    /abc/.send(@method, /abc/x).should_equal(false)
    /abc/x.send(@method, /abc/x).should_equal(true)
    /abc/u.send(@method, /abc/n).should_equal(false)
    /abc/u.send(@method, /abc/u).should_equal(true)
    /abc/n.send(@method, /abc/n).should_equal(true)
  end

  it.is "true if other has the same #casefold? values" do
    /abc/.send(@method, /abc/i).should_equal(false)
    /abc/i.send(@method, /abc/i).should_equal(true)
  end
end
