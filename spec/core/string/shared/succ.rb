describe :string_succ, :shared => true do
  it.returns "an empty string for empty strings" do
    "".send(@method).should_equal("")
  end
  
  it.returns "the successor by increasing the rightmost alphanumeric (digit => digit, letter => letter with same case)" do
    "abcd".send(@method).should_equal("abce")
    "THX1138".send(@method).should_equal("THX1139")
    
    "<<koala>>".send(@method).should_equal("<<koalb>>")
    "==A??".send(@method).should_equal("==B??")
  end
  
  it.will "increase non-alphanumerics (via ascii rules) if there are no alphanumerics" do
    "***".send(@method).should_equal("**+")
    "**`".send(@method).should_equal("**a")
  end
  
  it.will "increase the next best alphanumeric (jumping over non-alphanumerics) if there is a carry" do
    "dz".send(@method).should_equal("ea")
    "HZ".send(@method).should_equal("IA")
    "49".send(@method).should_equal("50")
    
    "izz".send(@method).should_equal("jaa")
    "IZZ".send(@method).should_equal("JAA")
    "699".send(@method).should_equal("700")
    
    "6Z99z99Z".send(@method).should_equal("7A00a00A")
    
    "1999zzz".send(@method).should_equal("2000aaa")
    "NZ/[]ZZZ9999".send(@method).should_equal("OA/[]AAA0000")
  end

  it.will "increase the next best character if there is a carry for non-alphanumerics" do
    "(\xFF".send(@method).should_equal(")\x00")
    "`\xFF".send(@method).should_equal("a\x00")
    "<\xFF\xFF".send(@method).should_equal("=\x00\x00")
  end

  it.will "add an additional character (just left to the last increased one) if there is a carry and no character left to increase" do
    "z".send(@method).should_equal("aa")
    "Z".send(@method).should_equal("AA")
    "9".send(@method).should_equal("10")
    
    "zz".send(@method).should_equal("aaa")
    "ZZ".send(@method).should_equal("AAA")
    "99".send(@method).should_equal("100")

    "9Z99z99Z".send(@method).should_equal("10A00a00A")

    "ZZZ9999".send(@method).should_equal("AAAA0000")
    "/[]ZZZ9999".send(@method).should_equal("/[]AAAA0000")
    "Z/[]ZZZ9999".send(@method).should_equal("AA/[]AAA0000")
    
    # non-alphanumeric cases
    "\xFF".send(@method).should_equal("\x01\x00")
    "\xFF\xFF".send(@method).should_equal("\x01\x00\x00")
  end

  it.returns "subclass instances when called on a subclass" do
    StringSpecs::MyString.new("").send(@method).class.should_equal(StringSpecs::MyString)
    StringSpecs::MyString.new("a").send(@method).class.should_equal(StringSpecs::MyString)
    StringSpecs::MyString.new("z").send(@method).class.should_equal(StringSpecs::MyString)
  end
  
  it.will "taint the result if self is tainted" do
    ["", "a", "z", "Z", "9", "\xFF", "\xFF\xFF"].each do |s|
      s.taint.send(@method).tainted?.should_equal(true)
    end
  end
end

describe :string_succ_bang, :shared => true do
  it.is "equivalent to succ, but modifies self in place (still returns self)" do
    ["", "abcd", "THX1138"].each do |s|
      r = s.dup.send(@method)
      s.send(@method).should_equal(s)
      s.should_equal(r)
    end
  end
end
