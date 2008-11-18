describe :string_slice, :shared => true do
  it.returns "the character code of the character at the given index" do
    "hello".send(@method, 0).should_equal(?h)
    "hello".send(@method, -1).should_equal(?o)
  end

  it.returns "nil if index is outside of self" do
    "hello".send(@method, 20).should_equal(nil)
    "hello".send(@method, -20).should_equal(nil)

    "".send(@method, 0).should_equal(nil)
    "".send(@method, -1).should_equal(nil)
  end

  it.calls " to_int on the given index" do
    "hello".send(@method, 0.5).should_equal(?h)

    obj = mock('1')
    obj.should_receive(:to_int).and_return(1)
    "hello".send(@method, obj).should_equal(?e)

    obj = mock('1')
    obj.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_int).and_return(1)
    "hello".send(@method, obj).should_equal(?e)
  end

  it.raises " a TypeError if the given index is nil" do
    lambda { "hello".send(@method, nil) }.should_raise(TypeError)
  end

  it.raises " a TypeError if the given index can't be converted to an Integer" do
    lambda { "hello".send(@method, mock('x')) }.should_raise(TypeError)
    lambda { "hello".send(@method, {})        }.should_raise(TypeError)
    lambda { "hello".send(@method, [])        }.should_raise(TypeError)
  end
end

describe :string_slice_index_length, :shared => true do
  it.returns "the substring starting at the given index with the given length" do
    "hello there".send(@method, 0,0).should_equal("")
    "hello there".send(@method, 0,1).should_equal("h")
    "hello there".send(@method, 0,3).should_equal("hel")
    "hello there".send(@method, 0,6).should_equal("hello ")
    "hello there".send(@method, 0,9).should_equal("hello the")
    "hello there".send(@method, 0,12).should_equal("hello there")

    "hello there".send(@method, 1,0).should_equal("")
    "hello there".send(@method, 1,1).should_equal("e")
    "hello there".send(@method, 1,3).should_equal("ell")
    "hello there".send(@method, 1,6).should_equal("ello t")
    "hello there".send(@method, 1,9).should_equal("ello ther")
    "hello there".send(@method, 1,12).should_equal("ello there")

    "hello there".send(@method, 3,0).should_equal("")
    "hello there".send(@method, 3,1).should_equal("l")
    "hello there".send(@method, 3,3).should_equal("lo ")
    "hello there".send(@method, 3,6).should_equal("lo the")
    "hello there".send(@method, 3,9).should_equal("lo there")

    "hello there".send(@method, 4,0).should_equal("")
    "hello there".send(@method, 4,3).should_equal("o t")
    "hello there".send(@method, 4,6).should_equal("o ther")
    "hello there".send(@method, 4,9).should_equal("o there")

    "foo".send(@method, 2,1).should_equal("o")
    "foo".send(@method, 3,0).should_equal("")
    "foo".send(@method, 3,1).should_equal("")

    "".send(@method, 0,0).should_equal("")
    "".send(@method, 0,1).should_equal("")

    "x".send(@method, 0,0).should_equal("")
    "x".send(@method, 0,1).should_equal("x")
    "x".send(@method, 1,0).should_equal("")
    "x".send(@method, 1,1).should_equal("")

    "x".send(@method, -1,0).should_equal("")
    "x".send(@method, -1,1).should_equal("x")

    "hello there".send(@method, -3,2).should_equal("er")
  end

  it.will "always taint resulting strings when self is tainted" do
    str = "hello world"
    str.taint

    str.send(@method, 0,0).tainted?.should_equal(true)
    str.send(@method, 0,1).tainted?.should_equal(true)
    str.send(@method, 2,1).tainted?.should_equal(true)
  end

  it.returns "nil if the offset falls outside of self" do
    "hello there".send(@method, 20,3).should_equal(nil)
    "hello there".send(@method, -20,3).should_equal(nil)

    "".send(@method, 1,0).should_equal(nil)
    "".send(@method, 1,1).should_equal(nil)

    "".send(@method, -1,0).should_equal(nil)
    "".send(@method, -1,1).should_equal(nil)

    "x".send(@method, 2,0).should_equal(nil)
    "x".send(@method, 2,1).should_equal(nil)

    "x".send(@method, -2,0).should_equal(nil)
    "x".send(@method, -2,1).should_equal(nil)
  end

  it.returns "nil if the length is negative" do
    "hello there".send(@method, 4,-3).should_equal(nil)
    "hello there".send(@method, -4,-3).should_equal(nil)
  end

  it.calls " to_int on the given index and the given length" do
    "hello".send(@method, 0.5, 1).should_equal("h")
    "hello".send(@method, 0.5, 2.5).should_equal("he")
    "hello".send(@method, 1, 2.5).should_equal("el")

    obj = mock('2')
    obj.should_receive(:to_int).exactly(4).times.and_return(2)

    "hello".send(@method, obj, 1).should_equal("l")
    "hello".send(@method, obj, obj).should_equal("ll")
    "hello".send(@method, 0, obj).should_equal("he")

    obj = mock('2')
    obj.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_int).exactly(2).times.and_return(2)
    "hello".send(@method, obj, obj).should_equal("ll")
  end

  it.raises " a TypeError when idx or length can't be converted to an integer" do
    lambda { "hello".send(@method, mock('x'), 0) }.should_raise(TypeError)
    lambda { "hello".send(@method, 0, mock('x')) }.should_raise(TypeError)

    # I'm deliberately including this here.
    # It means that str.send(@method, other, idx) isn't supported.
    lambda { "hello".send(@method, "", 0) }.should_raise(TypeError)
  end

  it.raises " a TypeError when the given index or the given length is nil" do
    lambda { "hello".send(@method, 1, nil)   }.should_raise(TypeError)
    lambda { "hello".send(@method, nil, 1)   }.should_raise(TypeError)
    lambda { "hello".send(@method, nil, nil) }.should_raise(TypeError)
  end

  it.returns "subclass instances" do
    s = StringSpecs::MyString.new("hello")
    s.send(@method, 0,0).class.should_equal(StringSpecs::MyString)
    s.send(@method, 0,4).class.should_equal(StringSpecs::MyString)
    s.send(@method, 1,4).class.should_equal(StringSpecs::MyString)
  end
end

describe :string_slice_range, :shared => true do
  it.returns "the substring given by the offsets of the range" do
    "hello there".send(@method, 1..1).should_equal("e")
    "hello there".send(@method, 1..3).should_equal("ell")
    "hello there".send(@method, 1...3).should_equal("el")
    "hello there".send(@method, -4..-2).should_equal("her")
    "hello there".send(@method, -4...-2).should_equal("he")
    "hello there".send(@method, 5..-1).should_equal(" there")
    "hello there".send(@method, 5...-1).should_equal(" ther")

    "".send(@method, 0..0).should_equal("")

    "x".send(@method, 0..0).should_equal("x")
    "x".send(@method, 0..1).should_equal("x")
    "x".send(@method, 0...1).should_equal("x")
    "x".send(@method, 0..-1).should_equal("x")

    "x".send(@method, 1..1).should_equal("")
    "x".send(@method, 1..-1).should_equal("")
  end

  it.returns "nil if the beginning of the range falls outside of self" do
    "hello there".send(@method, 12..-1).should_equal(nil)
    "hello there".send(@method, 20..25).should_equal(nil)
    "hello there".send(@method, 20..1).should_equal(nil)
    "hello there".send(@method, -20..1).should_equal(nil)
    "hello there".send(@method, -20..-1).should_equal(nil)

    "".send(@method, -1..-1).should_equal(nil)
    "".send(@method, -1...-1).should_equal(nil)
    "".send(@method, -1..0).should_equal(nil)
    "".send(@method, -1...0).should_equal(nil)
  end

  it.returns "an empty string if range.begin is inside self and > real end" do
    "hello there".send(@method, 1...1).should_equal("")
    "hello there".send(@method, 4..2).should_equal("")
    "hello".send(@method, 4..-4).should_equal("")
    "hello there".send(@method, -5..-6).should_equal("")
    "hello there".send(@method, -2..-4).should_equal("")
    "hello there".send(@method, -5..-6).should_equal("")
    "hello there".send(@method, -5..2).should_equal("")

    "".send(@method, 0...0).should_equal("")
    "".send(@method, 0..-1).should_equal("")
    "".send(@method, 0...-1).should_equal("")

    "x".send(@method, 0...0).should_equal("")
    "x".send(@method, 0...-1).should_equal("")
    "x".send(@method, 1...1).should_equal("")
    "x".send(@method, 1...-1).should_equal("")
  end

  it.will "always taint resulting strings when self is tainted" do
    str = "hello world"
    str.taint

    str.send(@method, 0..0).tainted?.should_equal(true)
    str.send(@method, 0...0).tainted?.should_equal(true)
    str.send(@method, 0..1).tainted?.should_equal(true)
    str.send(@method, 0...1).tainted?.should_equal(true)
    str.send(@method, 2..3).tainted?.should_equal(true)
    str.send(@method, 2..0).tainted?.should_equal(true)
  end

  it.returns "subclass instances" do
    s = StringSpecs::MyString.new("hello")
    s.send(@method, 0...0).class.should_equal(StringSpecs::MyString)
    s.send(@method, 0..4).class.should_equal(StringSpecs::MyString)
    s.send(@method, 1..4).class.should_equal(StringSpecs::MyString)
  end

  it.calls " to_int on range arguments" do
    from = mock('from')
    to = mock('to')

    # So we can construct a range out of them...
    def from.<=>(o) 0 end
    def to.<=>(o) 0 end

    def from.to_int() 1 end
    def to.to_int() -2 end

    "hello there".send(@method, from..to).should_equal("ello ther")
    "hello there".send(@method, from...to).should_equal("ello the")

    from = mock('from')
    to = mock('to')

    def from.<=>(o) 0 end
    def to.<=>(o) 0 end

    from.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    from.should_receive(:method_missing).with(:to_int).and_return(1)
    to.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    to.should_receive(:method_missing).with(:to_int).and_return(-2)

    "hello there".send(@method, from..to).should_equal("ello ther")
  end

  it.can "works with Range subclasses" do
    a = "GOOD"
    range_incl = StringSpecs::MyRange.new(1, 2)
    range_excl = StringSpecs::MyRange.new(-3, -1, true)

    a.send(@method, range_incl).should_equal("OO")
    a.send(@method, range_excl).should_equal("OO")
  end
end

describe :string_slice_regexp, :shared => true do
  it.returns "the matching portion of self" do
    "hello there".send(@method, /[aeiou](.)\1/).should_equal("ell")
    "".send(@method, //).should_equal("")
  end

  it.returns "nil if there is no match" do
    "hello there".send(@method, /xyz/).should_equal(nil)
  end

  it.will "always taint resulting strings when self or regexp is tainted" do
    strs = ["hello world"]
    strs += strs.map { |s| s.dup.taint }

    strs.each do |str|
      str.send(@method, //).tainted?.should_equal(str.tainted?)
      str.send(@method, /hello/).tainted?.should_equal(str.tainted?)

      tainted_re = /./
      tainted_re.taint

      str.send(@method, tainted_re).tainted?.should_equal(true)
    end
  end

  it.returns "subclass instances" do
    s = StringSpecs::MyString.new("hello")
    s.send(@method, //).class.should_equal(StringSpecs::MyString)
    s.send(@method, /../).class.should_equal(StringSpecs::MyString)
  end

  it.will "set $~ to MatchData when there is a match and nil when there's none" do
    'hello'.send(@method, /./)
    $~[0].should_equal('h')

    'hello'.send(@method, /not/)
    $~.should_equal(nil)
  end
end

describe :string_slice_regexp_index, :shared => true do
  it.returns "the capture for the given index" do
    "hello there".send(@method, /[aeiou](.)\1/, 0).should_equal("ell")
    "hello there".send(@method, /[aeiou](.)\1/, 1).should_equal("l")
    "hello there".send(@method, /[aeiou](.)\1/, -1).should_equal("l")

    "har".send(@method, /(.)(.)(.)/, 0).should_equal("har")
    "har".send(@method, /(.)(.)(.)/, 1).should_equal("h")
    "har".send(@method, /(.)(.)(.)/, 2).should_equal("a")
    "har".send(@method, /(.)(.)(.)/, 3).should_equal("r")
    "har".send(@method, /(.)(.)(.)/, -1).should_equal("r")
    "har".send(@method, /(.)(.)(.)/, -2).should_equal("a")
    "har".send(@method, /(.)(.)(.)/, -3).should_equal("h")
  end

  it.will "always taint resulting strings when self or regexp is tainted" do
    strs = ["hello world"]
    strs += strs.map { |s| s.dup.taint }

    strs.each do |str|
      str.send(@method, //, 0).tainted?.should_equal(str.tainted?)
      str.send(@method, /hello/, 0).tainted?.should_equal(str.tainted?)

      str.send(@method, /(.)(.)(.)/, 0).tainted?.should_equal(str.tainted?)
      str.send(@method, /(.)(.)(.)/, 1).tainted?.should_equal(str.tainted?)
      str.send(@method, /(.)(.)(.)/, -1).tainted?.should_equal(str.tainted?)
      str.send(@method, /(.)(.)(.)/, -2).tainted?.should_equal(str.tainted?)

      tainted_re = /(.)(.)(.)/
      tainted_re.taint

      str.send(@method, tainted_re, 0).tainted?.should_equal(true)
      str.send(@method, tainted_re, 1).tainted?.should_equal(true)
      str.send(@method, tainted_re, -1).tainted?.should_equal(true)
    end
  end

  it.returns "nil if there is no match" do
    "hello there".send(@method, /(what?)/, 1).should_equal(nil)
  end

  it.returns "nil if there is no capture for the given index" do
    "hello there".send(@method, /[aeiou](.)\1/, 2).should_equal(nil)
    # You can't refer to 0 using negative indices
    "hello there".send(@method, /[aeiou](.)\1/, -2).should_equal(nil)
  end

  it.calls " to_int on the given index" do
    obj = mock('2')
    obj.should_receive(:to_int).and_return(2)

    "har".send(@method, /(.)(.)(.)/, 1.5).should_equal("h")
    "har".send(@method, /(.)(.)(.)/, obj).should_equal("a")

    obj = mock('2')
    obj.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_int).and_return(2)
    "har".send(@method, /(.)(.)(.)/, obj).should_equal("a")
  end

  it.raises " a TypeError when the given index can't be converted to Integer" do
    lambda { "hello".send(@method, /(.)(.)(.)/, mock('x')) }.should_raise(TypeError)
    lambda { "hello".send(@method, /(.)(.)(.)/, {})        }.should_raise(TypeError)
    lambda { "hello".send(@method, /(.)(.)(.)/, [])        }.should_raise(TypeError)
  end

  it.raises " a TypeError when the given index is nil" do
    lambda { "hello".send(@method, /(.)(.)(.)/, nil) }.should_raise(TypeError)
  end

  it.returns "subclass instances" do
    s = StringSpecs::MyString.new("hello")
    s.send(@method, /(.)(.)/, 0).class.should_equal(StringSpecs::MyString)
    s.send(@method, /(.)(.)/, 1).class.should_equal(StringSpecs::MyString)
  end

  it.will "set $~ to MatchData when there is a match and nil when there's none" do
    'hello'.send(@method, /.(.)/, 0)
    $~[0].should_equal('he')

    'hello'.send(@method, /.(.)/, 1)
    $~[1].should_equal('e')

    'hello'.send(@method, /not/, 0)
    $~.should_equal(nil)
  end
end

describe :string_slice_string, :shared => true do
  it.returns "other_str if it occurs in self" do
    s = "lo"
    "hello there".send(@method, s).should_equal(s)
  end

  it.will "taint resulting strings when other is tainted" do
    strs = ["", "hello world", "hello"]
    strs += strs.map { |s| s.dup.taint }

    strs.each do |str|
      strs.each do |other|
        r = str.send(@method, other)

        r.tainted?.should_equal(!r.nil? & other.tainted?)
      end
    end
  end

  it.does_not " set $~" do
    $~ = nil

    'hello'.send(@method, 'll')
    $~.should_equal(nil)
  end

  it.returns "nil if there is no match" do
    "hello there".send(@method, "bye").should_equal(nil)
  end

  it.does_not " call to_str on its argument" do
    o = mock('x')
    o.should_not_receive(:to_str)

    lambda { "hello".send(@method, o) }.should_raise(TypeError)
  end

  it.returns "a subclass instance when given a subclass instance" do
    s = StringSpecs::MyString.new("el")
    r = "hello".send(@method, s)
    r.should_equal("el")
    r.class.should_equal(StringSpecs::MyString)
  end
end
