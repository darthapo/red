# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#%" do |it| 
  it.will "format multiple expressions" do
    ("%b %x %d %s" % [10, 10, 10, 10]).should_equal("1010 a 10 10")
  end
  
  it.will "format expressions mid string" do
    ("hello %s!" % "world").should_equal("hello world!")
  end
  
  it.will "format %% into %" do
    ("%d%% %s" % [10, "of chickens!"]).should_equal("10% of chickens!")
  end
  
  it.will "format single % characters before a newline or NULL as literal %s" do
    ("%" % []).should_equal("%")
    ("foo%" % []).should_equal("foo%")
    ("%\n" % []).should_equal("%\n")
    ("foo%\n" % []).should_equal("foo%\n")
    ("%\0" % []).should_equal("%\0")
    ("foo%\0" % []).should_equal("foo%\0")
    ("%\n.3f" % 1.2).should_equal("%\n.3f")
    ("%\0.3f" % 1.2).should_equal("%\0.3f")
  end
  
  it.raises " an error if single % appears anywhere else" do
    lambda { (" % " % []) }.should_raise(ArgumentError)
    lambda { ("foo%quux" % []) }.should_raise(ArgumentError)
  end

  it.raises " an error if NULL or \n appear anywhere else in the format string" do
    begin
      old_debug, $DEBUG = $DEBUG, false

      lambda { "%.\n3f" % 1.2 }.should_raise(ArgumentError)
      lambda { "%.3\nf" % 1.2 }.should_raise(ArgumentError)
      lambda { "%.\03f" % 1.2 }.should_raise(ArgumentError)
      lambda { "%.3\0f" % 1.2 }.should_raise(ArgumentError)
    ensure
      $DEBUG = old_debug
    end
  end

  it.will "ignore unused arguments when $DEBUG is false" do
    begin
      old_debug = $DEBUG
      $DEBUG = false

      ("" % [1, 2, 3]).should_equal("")
      ("%s" % [1, 2, 3]).should_equal("1")
    ensure
      $DEBUG = old_debug
    end
  end

  it.raises " an ArgumentError for unused arguments when $DEBUG is true" do
    begin
      old_debug = $DEBUG
      $DEBUG = true
      s = $stderr
      $stderr = IOStub.new

      lambda { "" % [1, 2, 3]   }.should_raise(ArgumentError)
      lambda { "%s" % [1, 2, 3] }.should_raise(ArgumentError)
    ensure
      $DEBUG = old_debug
      $stderr = s
    end
  end
  
  it.will "always allow unused arguments when positional argument style is used" do
    begin
      old_debug = $DEBUG
      $DEBUG = false
      
      ("%2$s" % [1, 2, 3]).should_equal("2")
      $DEBUG = true
      ("%2$s" % [1, 2, 3]).should_equal("2")
    ensure
      $DEBUG = old_debug
    end
  end
  
  it.will "replace trailing absolute argument specifier without type with percent sign" do
    ("hello %1$" % "foo").should_equal("hello %")
  end
  
  it.raises " an ArgumentError when given invalid argument specifiers" do
    lambda { "%1" % [] }.should_raise(ArgumentError)
    lambda { "%+" % [] }.should_raise(ArgumentError)
    lambda { "%-" % [] }.should_raise(ArgumentError)
    lambda { "%#" % [] }.should_raise(ArgumentError)
    lambda { "%0" % [] }.should_raise(ArgumentError)
    lambda { "%*" % [] }.should_raise(ArgumentError)
    lambda { "%." % [] }.should_raise(ArgumentError)
    lambda { "%_" % [] }.should_raise(ArgumentError)
    lambda { "%0$s" % "x"              }.should_raise(ArgumentError)
    lambda { "%*0$s" % [5, "x"]        }.should_raise(ArgumentError)
    lambda { "%*1$.*0$1$s" % [1, 2, 3] }.should_raise(ArgumentError)
  end

  it.raises " an ArgumentError when multiple positional argument tokens are given for one format specifier" do
    lambda { "%1$1$s" % "foo" }.should_raise(ArgumentError)
  end

  it.raises " an ArgumentError when multiple width star tokens are given for one format specifier" do
    lambda { "%**s" % [5, 5, 5] }.should_raise(ArgumentError)
  end

  it.raises " an ArgumentError when a width star token is seen after a width token" do
    lambda { "%5*s" % [5, 5] }.should_raise(ArgumentError)
  end

  it.raises " an ArgumentError when multiple precision tokens are given" do
    lambda { "%.5.5s" % 5      }.should_raise(ArgumentError)
    lambda { "%.5.*s" % [5, 5] }.should_raise(ArgumentError)
    lambda { "%.*.5s" % [5, 5] }.should_raise(ArgumentError)
  end
  
  it.raises " an ArgumentError when there are less arguments than format specifiers" do
    ("foo" % []).should_equal("foo")
    lambda { "%s" % []     }.should_raise(ArgumentError)
    lambda { "%s %s" % [1] }.should_raise(ArgumentError)
  end
  
  it.raises " an ArgumentError when absolute and relative argument numbers are mixed" do
    lambda { "%s %1$s" % "foo" }.should_raise(ArgumentError)
    lambda { "%1$s %s" % "foo" }.should_raise(ArgumentError)

    lambda { "%s %2$s" % ["foo", "bar"] }.should_raise(ArgumentError)
    lambda { "%2$s %s" % ["foo", "bar"] }.should_raise(ArgumentError)

    lambda { "%*2$s" % [5, 5, 5]     }.should_raise(ArgumentError)
    lambda { "%*.*2$s" % [5, 5, 5]   }.should_raise(ArgumentError)
    lambda { "%*2$.*2$s" % [5, 5, 5] }.should_raise(ArgumentError)
    lambda { "%*.*2$s" % [5, 5, 5]   }.should_raise(ArgumentError)
  end
  
  it.will "allow reuse of the one argument multiple via absolute argument numbers" do
    ("%1$s %1$s" % "foo").should_equal("foo foo")
    ("%1$s %2$s %1$s %2$s" % ["foo", "bar"]).should_equal("foo bar foo bar")
  end
  
  it.will "always interpret an array argument as a list of argument parameters" do
    lambda { "%p" % [] }.should_raise(ArgumentError)
    ("%p" % [1]).should_equal("1")
    ("%p %p" % [1, 2]).should_equal("1 2")
  end

  it.will "always interpret an array subclass argument as a list of argument parameters" do
    lambda { "%p" % StringSpecs::MyArray[] }.should_raise(ArgumentError)
    ("%p" % StringSpecs::MyArray[1]).should_equal("1")
    ("%p %p" % StringSpecs::MyArray[1, 2]).should_equal("1 2")
  end
  
  it.will "allow positional arguments for width star and precision star arguments" do
    ("%*1$.*2$3$d" % [10, 5, 1]).should_equal("     00001")
  end
  
  it.calls " to_int on width star and precision star tokens" do
    w = mock('10')
    def w.to_int() 10 end
    p = mock('5')
    def p.to_int() 5 end
    
    ("%*.*f" % [w, p, 1]).should_equal("   1.00000")
    
    w = mock('10')
    w.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    w.should_receive(:method_missing).with(:to_int).and_return(10)
    p = mock('5')
    p.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    p.should_receive(:method_missing).with(:to_int).and_return(5)

    ("%*.*f" % [w, p, 1]).should_equal("   1.00000")
  end

  it.does_not " return subclass instances when called on a subclass" do
    universal = mock('0')
    def universal.to_int() 0 end
    def universal.to_str() "0" end
    def universal.to_f() 0.0 end

    [
      "", "foo",
      "%b", "%B", "%c", "%d", "%e", "%E",
      "%f", "%g", "%G", "%i", "%o", "%p",
      "%s", "%u", "%x", "%X"
    ].each do |format|
      (StringSpecs::MyString.new(format) % universal).class.should_equal(String)
    end
  end

  it.will "always taint the result when the format string is tainted" do
    universal = mock('0')
    def universal.to_int() 0 end
    def universal.to_str() "0" end
    def universal.to_f() 0.0 end
    
    [
      "", "foo",
      "%b", "%B", "%c", "%d", "%e", "%E",
      "%f", "%g", "%G", "%i", "%o", "%p",
      "%s", "%u", "%x", "%X"
    ].each do |format|
      subcls_format = StringSpecs::MyString.new(format)
      subcls_format.taint
      format.taint
      
      (format % universal).tainted?.should_equal(true)
      (subcls_format % universal).tainted?.should_equal(true)
    end
  end

  it.supports "binary formats using %b" do
    ("%b" % 10).should_equal("1010")
    ("% b" % 10).should_equal(" 1010")
    ("%1$b" % [10, 20]).should_equal("1010")
    ("%#b" % 10).should_equal("0b1010")
    ("%+b" % 10).should_equal("+1010")
    ("%-9b" % 10).should_equal("1010     ")
    ("%05b" % 10).should_equal("01010")
    ("%*b" % [10, 6]).should_equal("       110")
    ("%*b" % [-10, 6]).should_equal("110       ")
    
    ("%b" % -5).should_equal("..1011")
    ("%0b" % -5).should_equal("1011")
    ("%.4b" % 2).should_equal("0010")
    ("%.1b" % -5).should_equal("1011")
    ("%.7b" % -5).should_equal("1111011")
    ("%.10b" % -5).should_equal("1111111011")
    ("% b" % -5).should_equal("-101")
    ("%+b" % -5).should_equal("-101")
    ("%b" % -(2 ** 64 + 5)).should ==
    "..101111111111111111111111111111111111111111111111111111111111111011"
  end
  
  it.supports "binary formats using %B with same behaviour as %b except for using 0B instead of 0b for #" do
    ("%B" % 10).should_equal(("%b" % 10))
    ("% B" % 10).should_equal(("% b" % 10))
    ("%1$B" % [10, 20]).should_equal(("%1$b" % [10, 20]))
    ("%+B" % 10).should_equal(("%+b" % 10))
    ("%-9B" % 10).should_equal(("%-9b" % 10))
    ("%05B" % 10).should_equal(("%05b" % 10))
    ("%*B" % [10, 6]).should_equal(("%*b" % [10, 6]))
    ("%*B" % [-10, 6]).should_equal(("%*b" % [-10, 6]))

    ("%B" % -5).should_equal(("%b" % -5))
    ("%0B" % -5).should_equal(("%0b" % -5))
    ("%.1B" % -5).should_equal(("%.1b" % -5))
    ("%.7B" % -5).should_equal(("%.7b" % -5))
    ("%.10B" % -5).should_equal(("%.10b" % -5))
    ("% B" % -5).should_equal(("% b" % -5))
    ("%+B" % -5).should_equal(("%+b" % -5))
    ("%B" % -(2 ** 64 + 5)).should_equal(("%b" % -(2 ** 64 + 5)))

    ("%#B" % 10).should_equal("0B1010")
  end
    
  it.supports "character formats using %c" do
    ("%c" % 10).should_equal("\n")
    ("%2$c" % [10, 11, 14]).should_equal("\v")
    ("%-4c" % 10).should_equal("\n   ")
    ("%*c" % [10, 3]).should_equal("         \003")
    ("%c" % (256 + 42)).should_equal("*")
    
    lambda { "%c" % Object }.should_raise(TypeError)
  end
  
  it.can "uses argument % 256" do
    ("%c" % [256 * 3 + 64]).should_equal(("%c" % 64))
    ("%c" % -200).should_equal(("%c" % 56))
  end

  it.calls " #to_ary on argument for %c formats" do
    obj = mock('65')
    obj.should_receive(:to_ary).and_return([65])
    ("%c" % obj).should_equal(("%c" % [65]))

    obj = mock('65')
    obj.should_receive(:respond_to?).with(:to_ary).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_ary).and_return([65])
    ("%c" % obj).should_equal("A")
  end

  it.calls " #to_int on argument for %c formats, if the argument does not respond to #to_ary" do
    obj = mock('65')
    def obj.to_int() 65 end
    ("%c" % obj).should_equal(("%c" % obj.to_int))

    obj = mock('65')
    obj.should_receive(:respond_to?).with(:to_ary).and_return(false)
    obj.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_int).and_return(65)
    ("%c" % obj).should_equal("A")
  end
  
  %w(d i).each do |f|
    format = "%" + f
    
    it.supports "integer formats using #{format}" do
      ("%#{f}" % 10).should_equal("10")
      ("% #{f}" % 10).should_equal(" 10")
      ("%1$#{f}" % [10, 20]).should_equal("10")
      ("%+#{f}" % 10).should_equal("+10")
      ("%-7#{f}" % 10).should_equal("10     ")
      ("%04#{f}" % 10).should_equal("0010")
      ("%*#{f}" % [10, 4]).should_equal("         4")
    end
  end

  it.supports "float formats using %e" do
    ("%e" % 10).should_equal("1.000000e+01")
    ("% e" % 10).should_equal(" 1.000000e+01")
    ("%1$e" % 10).should_equal("1.000000e+01")
    ("%#e" % 10).should_equal("1.000000e+01")
    ("%+e" % 10).should_equal("+1.000000e+01")
    ("%-7e" % 10).should_equal("1.000000e+01")
    ("%05e" % 10).should_equal("1.000000e+01")
    ("%*e" % [10, 9]).should_equal("9.000000e+00")
  end
  
  it.supports "float formats using %E" do
    ("%E" % 10).should_equal("1.000000E+01")
    ("% E" % 10).should_equal(" 1.000000E+01")
    ("%1$E" % 10).should_equal("1.000000E+01")
    ("%#E" % 10).should_equal("1.000000E+01")
    ("%+E" % 10).should_equal("+1.000000E+01")
    ("%-7E" % 10).should_equal("1.000000E+01")
    ("%05E" % 10).should_equal("1.000000E+01")
    ("%*E" % [10, 9]).should_equal("9.000000E+00")
  end
  
  it.supports "float formats using %f" do
    ("%f" % 10).should_equal("10.000000")
    ("% f" % 10).should_equal(" 10.000000")
    ("%1$f" % 10).should_equal("10.000000")
    ("%#f" % 10).should_equal("10.000000")
    ("%+f" % 10).should_equal("+10.000000")
    ("%-7f" % 10).should_equal("10.000000")
    ("%05f" % 10).should_equal("10.000000")
    ("%*f" % [10, 9]).should_equal("  9.000000")
  end
  
  it.supports "float formats using %g" do
    ("%g" % 10).should_equal("10")
    ("% g" % 10).should_equal(" 10")
    ("%1$g" % 10).should_equal("10")
    ("%#g" % 10).should_equal("10.0000")
    ("%+g" % 10).should_equal("+10")
    ("%-7g" % 10).should_equal("10     ")
    ("%05g" % 10).should_equal("00010")
    ("%*g" % [10, 9]).should_equal("         9")
  end
  
  it.supports "float formats using %G" do
    ("%G" % 10).should_equal("10")
    ("% G" % 10).should_equal(" 10")
    ("%1$G" % 10).should_equal("10")
    ("%#G" % 10).should_equal("10.0000")
    ("%+G" % 10).should_equal("+10")
    ("%-7G" % 10).should_equal("10     ")
    ("%05G" % 10).should_equal("00010")
    ("%*G" % [10, 9]).should_equal("         9")
  end
  
  it.supports "octal formats using %o" do
    ("%o" % 10).should_equal("12")
    ("% o" % 10).should_equal(" 12")
    ("%1$o" % [10, 20]).should_equal("12")
    ("%#o" % 10).should_equal("012")
    ("%+o" % 10).should_equal("+12")
    ("%-9o" % 10).should_equal("12       ")
    ("%05o" % 10).should_equal("00012")
    ("%*o" % [10, 6]).should_equal("         6")

    # These are incredibly wrong. -05 == -5, not 7177777...whatever
    ("%o" % -5).should_equal("..73")
    ("%0o" % -5).should_equal("73")
    ("%.4o" % 20).should_equal("0024")
    ("%.1o" % -5).should_equal("73")
    ("%.7o" % -5).should_equal("7777773")
    ("%.10o" % -5).should_equal("7777777773")

    ("% o" % -26).should_equal("-32")
    ("%+o" % -26).should_equal("-32")
    ("%o" % -(2 ** 64 + 5)).should_equal("..75777777777777777777773")
  end
  
  it.supports "inspect formats using %p" do
    ("%p" % 10).should_equal("10")
    ("%1$p" % [10, 5]).should_equal("10")
    ("%-22p" % 10).should_equal("10                    ")
    ("%*p" % [10, 10]).should_equal("        10")
  end
  
  it.calls " inspect on arguments for %p format" do
    obj = mock('obj')
    def obj.inspect() "obj" end
    ("%p" % obj).should_equal("obj")

    # undef is not working
    # obj = mock('obj')
    # class << obj; undef :inspect; end
    # def obj.method_missing(*args) "obj" end
    # ("%p" % obj).should_equal("obj"    )
  end
  
  it.will "taint result for %p when argument.inspect is tainted" do
    obj = mock('x')
    def obj.inspect() "x".taint end
    
    ("%p" % obj).tainted?.should_equal(true)
    
    obj = mock('x'); obj.taint
    def obj.inspect() "x" end
    
    ("%p" % obj).tainted?.should_equal(false)
  end
  
  it.supports "string formats using %s" do
    ("%s" % 10).should_equal("10")
    ("%1$s" % [10, 8]).should_equal("10")
    ("%-5s" % 10).should_equal("10   ")
    ("%*s" % [10, 9]).should_equal("         9")
  end
  
  it.calls " to_s on arguments for %s format" do
    obj = mock('obj')
    def obj.to_s() "obj" end
    
    ("%s" % obj).should_equal("obj")

    # undef doesn't work
    # obj = mock('obj')
    # class << obj; undef :to_s; end
    # def obj.method_missing(*args) "obj" end
    # 
    # ("%s" % obj).should_equal("obj")
  end
  
  it.will "taint result for %s when argument is tainted" do
    ("%s" % "x".taint).tainted?.should_equal(true)
    ("%s" % mock('x').taint).tainted?.should_equal(true)
    ("%s" % 5.0.taint).tainted?.should_equal(true)
  end

  # MRI crashes on this one.
  # See http://groups.google.com/group/ruby-core-google/t/c285c18cd94c216d
  it.raises " an ArgumentError for huge precisions for %s" do
    block = lambda { "%.25555555555555555555555555555555555555s" % "hello world" }
    block.should_raise(ArgumentError)
  end
  
  # Note: %u has been changed to an alias for %d in MRI 1.9 trunk.
  # Let's wait a bit for it to cool down and see if it will
  # be changed for 1.8 as well.
  it.supports "unsigned formats using %u" do
    ("%u" % 10).should_equal("10")
    ("% u" % 10).should_equal(" 10")
    ("%1$u" % [10, 20]).should_equal("10")
    ("%+u" % 10).should_equal("+10")
    ("%-7u" % 10).should_equal("10     ")
    ("%04u" % 10).should_equal("0010")
    ("%*u" % [10, 4]).should_equal("         4")

  end
  
  it.supports "hex formats using %x" do
    ("%x" % 10).should_equal("a")
    ("% x" % 10).should_equal(" a")
    ("%1$x" % [10, 20]).should_equal("a")
    ("%#x" % 10).should_equal("0xa")
    ("%+x" % 10).should_equal("+a")
    ("%-9x" % 10).should_equal("a        ")
    ("%05x" % 10).should_equal("0000a")
    ("%*x" % [10, 6]).should_equal("         6")

    ("%x" % -5).should_equal("..fb")
    ("%0x" % -5).should_equal("fb")
    ("%.4x" % 20).should_equal("0014")
    ("%.1x" % -5).should_equal("fb")
    ("%.7x" % -5).should_equal("ffffffb")
    ("%.10x" % -5).should_equal("fffffffffb")
    ("% x" % -26).should_equal("-1a")
    ("%+x" % -26).should_equal("-1a")
    ("%x" % 0xFFFFFFFF).should_equal("ffffffff")
    ("%x" % -(2 ** 64 + 5)).should_equal("..fefffffffffffffffb")
  end
  
  it.supports "hex formats using %X" do
    ("%X" % 10).should_equal("A")
    ("% X" % 10).should_equal(" A")
    ("%1$X" % [10, 20]).should_equal("A")
    ("%#X" % 10).should_equal("0XA")
    ("%+X" % 10).should_equal("+A")
    ("%-9X" % 10).should_equal("A        ")
    ("%05X" % 10).should_equal("0000A")
    ("%*X" % [10, 6]).should_equal("         6")
    
    ("%X" % -5).should_equal("..FB")
    ("%0X" % -5).should_equal("FB")
    ("%.1X" % -5).should_equal("FB")
    ("%.7X" % -5).should_equal("FFFFFFB")
    ("%.10X" % -5).should_equal("FFFFFFFFFB")
    ("% X" % -26).should_equal("-1A")
    ("%+X" % -26).should_equal("-1A")
    ("%X" % 0xFFFFFFFF).should_equal("FFFFFFFF")
    ("%X" % -(2 ** 64 + 5)).should_equal("..FEFFFFFFFFFFFFFFFB")
  end
  
  %w(b d i o u x X).each do |f|
    format = "%" + f
    
    it.behaves "as if calling Kernel#Integer for #{format} argument, if it does not respond to #to_ary" do
      (format % "10").should_equal((format % Kernel.Integer("10")))
      (format % nil).should_equal((format % Kernel.Integer(nil)))
      (format % "0x42").should_equal((format % Kernel.Integer("0x42")))
      (format % "0b1101").should_equal((format % Kernel.Integer("0b1101")))
      (format % "0b1101_0000").should_equal((format % Kernel.Integer("0b1101_0000")))
      (format % "0777").should_equal((format % Kernel.Integer("0777")))
      lambda {
        # see [ruby-core:14139] for more details
        (format % "0777").should_equal((format % Kernel.Integer("0777")))
      }.should_not raise_error(ArgumentError)

      lambda { format % "0__7_7_7" }.should_raise(ArgumentError)
      
      lambda { format % "" }.should_raise(ArgumentError)
      lambda { format % "x" }.should_raise(ArgumentError)
      lambda { format % "5x" }.should_raise(ArgumentError)
      lambda { format % "08" }.should_raise(ArgumentError)
      lambda { format % "0b2" }.should_raise(ArgumentError)
      lambda { format % "123__456" }.should_raise(ArgumentError)
      
      obj = mock('5')
      obj.should_receive(:to_i).and_return(5)
      (format % obj).should_equal((format % 5))

      obj = mock('5')
      obj.should_receive(:to_int).and_return(5)
      (format % obj).should_equal((format % 5))

      obj = mock('4')
      def obj.to_int() 4 end
      def obj.to_i() 0 end
      (format % obj).should_equal((format % 4))

      obj = mock('65')
      obj.should_receive(:respond_to?).with(:to_ary).any_number_of_times.and_return(false)
      obj.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(true)
      obj.should_receive(:method_missing).with(:to_int).and_return(65)
      (format % obj).should_equal((format % 65))

      obj = mock('65')
      obj.should_receive(:respond_to?).with(:to_ary).any_number_of_times.and_return(false)
      obj.should_receive(:respond_to?).with(:to_int).any_number_of_times.and_return(false)
      obj.should_receive(:respond_to?).with(:to_i).any_number_of_times.and_return(true)
      obj.should_receive(:method_missing).with(:to_i).any_number_of_times.and_return(65)
      (format % obj).should_equal((format % 65))
      
      obj = mock('4')
      def obj.respond_to?(arg) [:to_i, :to_int].include?(arg) end
      def obj.method_missing(name, *args)
        name == :to_int ? 4 : 0 unless name == :to_ary
      end
      (format % obj).should_equal((format % 4))
    end
    
    it.does_not " taint the result for #{format} when argument is tainted" do
      (format % "5".taint).tainted?.should_equal(false)
    end
  end
  
  %w(e E f g G).each do |f|
    format = "%" + f
    
    it.tries "to convert the passed argument to an Array using #to_ary" do
      obj = mock('3.14')
      obj.should_receive(:respond_to?).with(:to_ary).any_number_of_times.and_return(true)
      obj.should_receive(:method_missing).with(:to_ary).and_return([3.14])
      (format % obj).should_equal((format % [3.14]))
    end
    
    it.behaves "as if calling Kernel#Float for #{format} arguments, when the passed argument does not respond to #to_ary" do
      (format % 10).should_equal((format % 10.0))
      (format % "-10.4e-20").should_equal((format % -10.4e-20))
      (format % ".5").should_equal((format % 0.5))
      (format % "-.5").should_equal((format % -0.5))
      # Something's strange with this spec:
      # it works just fine in individual mode, but not when run as part of a group
      (format % "10_1_0.5_5_5").should_equal((format % 1010.555))
      
      (format % "0777").should_equal((format % 777))

      lambda { format % "" }.should_raise(ArgumentError)
      lambda { format % "x" }.should_raise(ArgumentError)
      lambda { format % "." }.should_raise(ArgumentError)
      lambda { format % "10." }.should_raise(ArgumentError)
      lambda { format % "5x" }.should_raise(ArgumentError)
      lambda { format % "0xA" }.should_raise(ArgumentError)
      lambda { format % "0b1" }.should_raise(ArgumentError)
      lambda { format % "10e10.5" }.should_raise(ArgumentError)
      lambda { format % "10__10" }.should_raise(ArgumentError)
      lambda { format % "10.10__10" }.should_raise(ArgumentError)
      
      obj = mock('5.0')
      obj.should_receive(:to_f).and_return(5.0)
      (format % obj).should_equal((format % 5.0))

      obj = mock('3.14')
      obj.should_receive(:respond_to?).with(:to_ary).any_number_of_times.and_return(false)
      obj.should_receive(:respond_to?).with(:to_f).any_number_of_times.and_return(true)
      obj.should_receive(:method_missing).with(:to_f).and_return(3.14)
      (format % obj).should_equal((format % 3.14))
    end
    
    it.does_not " taint the result for #{format} when argument is tainted" do
      (format % "5".taint).tainted?.should_equal(false)
    end
  end
end
