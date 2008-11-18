describe :string_each, :shared => true do
  it.will "split self using the supplied record separator and passes each substring to the block" do
    a = []
    "one\ntwo\r\nthree".send(@method, "\n") { |s| a << s }
    a.should_equal(["one\n", "two\r\n", "three"])

    b = []
    "hello\nworld".send(@method, 'l') { |s| b << s }
    b.should_equal([ "hel", "l", "o\nworl", "d" ])

    c = []
    "hello\n\n\nworld".send(@method, "\n") { |s| c << s }
    c.should_equal(["hello\n", "\n", "\n", "world"])
  end

  it.will "taint substrings that are passed to the block if self is tainted" do
    "one\ntwo\r\nthree".taint.send(@method) { |s| s.tainted?.should_equal(true })

    "x.y.".send(@method, ".".taint) { |s| s.tainted?.should_equal(false })
  end

  it.will "passe self as a whole to the block if the separator is nil" do
    a = []
    "one\ntwo\r\nthree".send(@method, nil) { |s| a << s }
    a.should_equal(["one\ntwo\r\nthree"])
  end

  it.will "append multiple successive newlines together when the separator is an empty string" do
    a = []
    "hello\nworld\n\n\nand\nuniverse\n\n\n\n\n".send(@method, '') { |s| a << s }
    a.should_equal(["hello\nworld\n\n\n", "and\nuniverse\n\n\n\n\n"])
  end

  it.will "use $/ as the separator when none is given" do
    [
      "", "x", "x\ny", "x\ry", "x\r\ny", "x\n\r\r\ny",
      "hello hullo bello"
    ].each do |str|
      ["", "llo", "\n", "\r", nil].each do |sep|
        begin
          expected = []
          str.send(@method, sep) { |x| expected << x }

          old_rec_sep, $/ = $/, sep

          actual = []
          str.send(@method) { |x| actual << x }

          actual.should_equal(expected)
        ensure
          $/ = old_rec_sep
        end
      end
    end
  end

  it.yields "subclass instances for subclasses" do
    a = []
    StringSpecs::MyString.new("hello\nworld").send(@method) { |s| a << s.class }
    a.should_equal([StringSpecs::MyString, StringSpecs::MyString])
  end

  it.returns "self" do
    s = "hello\nworld"
    (s.send(@method) {}).should_equal(s)
  end

  it.tries "to convert the separator to a string using to_str" do
    separator = mock('l')
    def separator.to_str() 'l' end

    a = []
    "hello\nworld".send(@method, separator) { |s| a << s }
    a.should_equal([ "hel", "l", "o\nworl", "d" ])

    obj = mock('l')
    obj.should_receive(:respond_to?).with(:to_str).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_str).and_return("l")

    a = []
    "hello\nworld".send(@method, obj) { |s| a << s }
    a.should_equal([ "hel", "l", "o\nworl", "d" ])
  end

  it.raises " a RuntimeError if the string is modified while substituting" do
    str = "hello\nworld"
    lambda { str.send(@method) { str[0] = 'x' } }.should_raise(RuntimeError)
  end

  it.raises " a TypeError when the separator can't be converted to a string" do
    lambda { "hello world".send(@method, false) {}     }.should_raise(TypeError)
    lambda { "hello world".send(@method, ?o) {}        }.should_raise(TypeError)
    lambda { "hello world".send(@method, :o) {}        }.should_raise(TypeError)
    lambda { "hello world".send(@method, mock('x')) {} }.should_raise(TypeError)
  end
end
