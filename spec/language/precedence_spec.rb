# require File.dirname(__FILE__) + '/../spec_helper'

# Specifying the behavior of operators in combination could
# lead to combinatorial explosion. A better way seems to be
# to use a technique from formal proofs that involve a set of
# equivalent statements. Suppose you have statements A, B, C.
# If they are claimed to be equivalent, this can be shown by
# proving that A implies B, B implies C, and C implies A.
# (Actually any closed circuit of implications.)
#
# Here, we can use a similar technique where we show starting
# at the top that each level of operator has precedence over
# the level below (as well as showing associativity within
# the precedence level).

=begin
Excerpted from 'Programming Ruby: The Pragmatic Programmer's Guide'
Second Edition by Dave Thomas, Chad Fowler, and Andy Hunt, page 324

Table 22.4. Ruby operators (high to low precedence)
Method   Operator                  Description
-----------------------------------------------------------------------
         :: .
 x*      [ ] [ ]=                  Element reference, element set
 x       **                        Exponentiation
 x       ! ~ + -                   Not, complement, unary plus and minus
                                   (method names for the last two are +@ and -@)
 x       * / %                     Multiply, divide, and modulo
 x       + -                       Plus and minus
 x       >> <<                     Right and left shift
 x       &                         “And” (bitwise for integers)
 x       ^ |                       Exclusive “or” and regular “or” (bitwise for integers)
 x       <= < > >=                 Comparison operators
 x       <=> == === != =~ !~       Equality and pattern match operators (!=
                                   and !~ may not be defined as methods)
         &&                        Logical “and”
         ||                        Logical “or”
         .. ...                    Range (inclusive and exclusive)
         ? :                       Ternary if-then-else
         = %= /= -= += |= &=       Assignment
         >>= <<= *= &&= ||= **=
         defined?                  Check if symbol defined
         not                       Logical negation
         or and                    Logical composition
         if unless while until     Expression modifiers
         begin/end                 Block expression
-----------------------------------------------------------------------

* Operators marked with 'x' in the Method column are implemented as methods
and can be overridden (except != and !~ as noted). (But see the specs
below for implementations that define != and !~ as methods.)

** These are not included in the excerpted table but are shown here for
completeness.
=end

# -----------------------------------------------------------------------
# It seems that this table is not correct as of MRI 1.8.6
# The correct table derived from MRI's parse.y is as follows:
#
# Operator              Assoc    Description
#---------------------------------------------------------------
# ! ~ +                   >      Not, complement, unary plus
# **                      >      Exponentiation
# -                       >      Unary minus
# * / %                   <      Multiply, divide, and modulo
# + -                     <      Plus and minus
# >> <<                   <      Right and left shift
# &                       <      “And” (bitwise for integers)
# ^ |                     <      Exclusive “or” and regular “or” (bitwise for integers)
# <= < > >=               <      Comparison operators
# <=> == === != =~ !~     no     Equality and pattern match operators (!=
#                                and !~ may not be defined as methods)
# &&                      <      Logical “and”
# ||                      <      Logical “or”
# .. ...                  no     Range (inclusive and exclusive)
# ? :                     >      Ternary if-then-else
# rescue                  <      Rescue modifier
# = %= /= -= += |= &=     >      Assignment
# >>= <<= *= &&= ||= **=
# defined?                no     Check if symbol defined
# not                     >      Logical negation
# or and                  <      Logical composition
# if unless while until   no     Expression modifiers
# -----------------------------------------------------------------------
#
# [] and []= seem to fall out of here, as well as begin/end
#

# TODO: Resolve these two tables with actual specs. As the comment at the
# top suggests, these specs need to be reorganized into a single describe
# block for each operator. The describe block should_include an example
# for associativity (if relevant), an example for any short circuit behavior
# (e.g. &&, ||, etc.) and an example block for each operator over which the
# instant operator has immediately higher precedence.

describe "Operators" do |it| 
  it.can "! ~ + is right-associative" do
    (!!true).should_equal(true)
    (~~0).should_equal(0)
    (++2).should_equal(2)
  end

  it.can "! ~ + have a higher precedence than **" do
    class FalseClass; def **(a); 1000; end; end
    (!0**2).should_equal(1000)
    class FalseClass; undef_method :**; end

    class UnaryPlusTest; def +@; 50; end; end
    a = UnaryPlusTest.new
    (+a**2).should_equal(2500)

    (~0**2).should_equal(1)
  end

  it.can "** is right-associative" do
    (2**2**3).should_equal(256)
  end

  it.can "** has higher precedence than unary minus" do
    (-2**2).should_equal(-4)
  end

  it.can "unary minus is right-associative" do
    (--2).should_equal(2)
  end

  it.can "unary minus has higher precedence than * / %" do
    class UnaryMinusTest; def -@; 50; end; end
    b = UnaryMinusTest.new

    (-b * 5).should_equal(250)
    (-b / 5).should_equal(10)
    (-b % 7).should_equal(1)
  end

  it.can "* / % are left-associative" do
    (2*1/2).should     == (2*1)/2
    # Guard against the Mathn library
    # TODO: Make these specs not rely on specific behaviour / result values
    # by using mocks.
    conflicts_with :Prime do
      (2*1/2).should_not == 2*(1/2)
    end

    (10/7/5).should     == (10/7)/5
    (10/7/5).should_not == 10/(7/5)

    (101 % 55 % 7).should     == (101 % 55) % 7
    (101 % 55 % 7).should_not == 101 % (55 % 7)

    (50*20/7%42).should     == ((50*20)/7)%42
    (50*20/7%42).should_not == 50*(20/(7%42))
  end

  it.can "* / % have higher precedence than + -" do
    (2+2*2).should_equal(6)
    (1+10/5).should_equal(3)
    (2+10%5).should_equal(2)

    (2-2*2).should_equal(-2)
    (1-10/5).should_equal(-1)
    (10-10%4).should_equal(8)
  end

  it.can "+ - are left-associative" do
    (2-3-4).should_equal(-5)
    (4-3+2).should_equal(3)

    class BinaryPlusTest < String; alias_method :plus, :+; def +(a); plus(a) + "!"; end; end
    s = BinaryPlusTest.new("a")

    (s+s+s).should_equal((s+s)+s)
    (s+s+s).should_not == s+(s+s)
  end

  it.can "+ - have higher precedence than >> <<" do
    (2<<1+2).should_equal(16)
    (8>>1+2).should_equal(1)
    (4<<1-3).should_equal(1)
    (2>>1-3).should_equal(8)
  end

  it.can ">> << are left-associative" do
    (1 << 2 << 3).should_equal(32)
    (10 >> 1 >> 1).should_equal(2)
    (10 << 4 >> 1).should_equal(80)
  end

  it.can ">> << have higher precedence than &" do
    (4 & 2 << 1).should_equal(4)
    (2 & 4 >> 1).should_equal(2)
  end

  it.can "& is left-associative" do
    class BitwiseAndTest; def &(a); a+1; end; end
    c = BitwiseAndTest.new

    (c & 5 & 2).should     == (c & 5) & 2
    (c & 5 & 2).should_not == c & (5 & 2)
  end

  it.can "& has higher precedence than ^ |" do
    (8 ^ 16 & 16).should_equal(24)
    (8 | 16 & 16).should_equal(24)
  end

  it.can "^ | are left-associative" do
    class OrAndXorTest; def ^(a); a+10; end; def |(a); a-10; end; end
    d = OrAndXorTest.new

    (d ^ 13 ^ 16).should     == (d ^ 13) ^ 16
    (d ^ 13 ^ 16).should_not == d ^ (13 ^ 16)

    (d | 13 | 4).should     == (d | 13) | 4
    (d | 13 | 4).should_not == d | (13 | 4)
  end

  it.can "^ | have higher precedence than <= < > >=" do
    (10 <= 7 ^ 7).should_equal(false)
    (10 < 7 ^ 7).should_equal(false)
    (10 > 7 ^ 7).should_equal(true)
    (10 >= 7 ^ 7).should_equal(true)
    (10 <= 7 | 7).should_equal(false)
    (10 < 7 | 7).should_equal(false)
    (10 > 7 | 7).should_equal(true)
    (10 >= 7 | 7).should_equal(true)
  end

  it.can "<= < > >= are left-associative" do
    class ComparisonTest
      def <=(a); 0; end;
      def <(a);  0; end;
      def >(a);  0; end;
      def >=(a); 0; end;
    end

    e = ComparisonTest.new

    (e <= 0 <= 1).should     == (e <= 0) <= 1
    (e <= 0 <= 1).should_not == e <= (0 <= 1)

    (e < 0 < 1).should     == (e < 0) < 1
    (e < 0 < 1).should_not == e < (0 < 1)

    (e >= 0 >= 1).should     == (e >= 0) >= 1
    (e >= 0 >= 1).should_not == e >= (0 >= 1)

    (e > 0 > 1).should     == (e > 0) > 1
    (e > 0 > 1).should_not == e > (0 > 1)
  end

  it.can "<= < > >= have higher precedence than <=> == === != =~ !~" do
    (1 <=> 5 <  1).should_equal(nil)
    (1 <=> 5 <= 1).should_equal(nil)
    (1 <=> 5 >  1).should_equal(nil)
    (1 <=> 5 >= 1).should_equal(nil)

    (1 == 5 <  1).should_equal(false)
    (1 == 5 <= 1).should_equal(false)
    (1 == 5 >  1).should_equal(false)
    (1 == 5 >= 1).should_equal(false)

    (1 === 5 <  1).should_equal(false)
    (1 === 5 <= 1).should_equal(false)
    (1 === 5 >  1).should_equal(false)
    (1 === 5 >= 1).should_equal(false)

    (1 != 5 <  1).should_equal(true)
    (1 != 5 <= 1).should_equal(true)
    (1 != 5 >  1).should_equal(true)
    (1 != 5 >= 1).should_equal(true)

    (1 =~ 5 <  1).should_equal(false)
    (1 =~ 5 <= 1).should_equal(false)
    (1 =~ 5 >  1).should_equal(false)
    (1 =~ 5 >= 1).should_equal(false)

    (1 !~ 5 <  1).should_equal(true)
    (1 !~ 5 <= 1).should_equal(true)
    (1 !~ 5 >  1).should_equal(true)
    (1 !~ 5 >= 1).should_equal(true)
  end

  it.can "<=> == === != =~ !~ are non-associative" do
    lambda { eval("1 <=> 2 <=> 3")  }.should_raise(SyntaxError)
    lambda { eval("1 == 2 == 3")  }.should_raise(SyntaxError)
    lambda { eval("1 === 2 === 3")  }.should_raise(SyntaxError)
    lambda { eval("1 != 2 != 3")  }.should_raise(SyntaxError)
    lambda { eval("1 =~ 2 =~ 3")  }.should_raise(SyntaxError)
    lambda { eval("1 !~ 2 !~ 3")  }.should_raise(SyntaxError)
  end

  it.can "<=> == === != =~ !~ have higher precedence than &&" do
    (false && 2 <=> 3).should_equal(false)
    (false && 3 == false).should_equal(false)
    (false && 3 === false).should_equal(false)
    (false && 3 != true).should_equal(false)

    class FalseClass; def =~(o); o == false; end; end
    (false && true =~ false).should     == (false && (true =~ false))
    (false && true =~ false).should_not == ((false && true) =~ false)
    class FalseClass; undef_method :=~; end

    (false && true !~ true).should_equal(false)
  end

  # XXX: figure out how to test it
  # (a && b) && c equals to a && (b && c) for all a,b,c values I can imagine so far
  it.can "&& is left-associative"

  it.can "&& has higher precedence than ||" do
    (true || false && false).should_equal(true)
  end

  # XXX: figure out how to test it
  it.can "|| is left-associative"

  it.can "|| has higher precedence than .. ..." do
    (1..false||10).should_equal((1..10))
    (1...false||10).should_equal((1...10))
  end

  it.can ".. ... are non-associative" do
    lambda { eval("1..2..3")  }.should_raise(SyntaxError)
    lambda { eval("1...2...3")  }.should_raise(SyntaxError)
  end

# XXX: this is commented now due to a bug in compiler, which cannot
# distinguish between range and flip-flop operator so far. zenspider is
# currently working on a new lexer, which will be able to do that.
# As soon as it's done, these piece should be reenabled.
#
#  it.can ".. ... have higher precedence than ? :" do
#    (1..2 ? 3 : 4).should_equal(3)
#    (1...2 ? 3 : 4).should_equal(3)
#  end

  it.can "? : is right-associative" do
    (true ? 2 : 3 ? 4 : 5).should_equal(2)
  end

  def oops; raise end

  it.can "? : has higher precedence than rescue" do

    (true ? oops : 0 rescue 10).should_equal(10)
  end

  # XXX: figure how to test it (problem similar to || associativity)
  it.can "rescue is left-associative"

  it.can "rescue has higher precedence than =" do
    a = oops rescue 10
    a.should_equal(10)

    # rescue doesn't have the same sense for %= /= and friends
  end

  it.can "= %= /= -= += |= &= >>= <<= *= &&= ||= **= are right-associative" do
    a = b = 10
    a.should_equal(10)
    b.should_equal(10)

    a = b = 10
    a %= b %= 3
    a.should_equal(0)
    b.should_equal(1)

    a = b = 10
    a /= b /= 2
    a.should_equal(2)
    b.should_equal(5)

    a = b = 10
    a -= b -= 2
    a.should_equal(2)
    b.should_equal(8)

    a = b = 10
    a += b += 2
    a.should_equal(22)
    b.should_equal(12)

    a,b = 32,64
    a |= b |= 2
    a.should_equal(98)
    b.should_equal(66)

    a,b = 25,13
    a &= b &= 7
    a.should_equal(1)
    b.should_equal(5)

    a,b=8,2
    a >>= b >>= 1
    a.should_equal(4)
    b.should_equal(1)

    a,b=8,2
    a <<= b <<= 1
    a.should_equal(128)
    b.should_equal(4)

    a,b=8,2
    a *= b *= 2
    a.should_equal(32)
    b.should_equal(4)

    a,b=10,20
    a &&= b &&= false
    a.should_equal(false)
    b.should_equal(false)

    a,b=nil,nil
    a ||= b ||= 10
    a.should_equal(10)
    b.should_equal(10)

    a,b=2,3
    a **= b **= 2
    a.should_equal(512)
    b.should_equal(9)
  end

  it.can "= %= /= -= += |= &= >>= <<= *= &&= ||= **= have higher precedence than defined? operator" do
    (defined? a =   10).should_not == nil
    (defined? a %=  10).should_not == nil
    (defined? a /=  10).should_not == nil
    (defined? a -=  10).should_not == nil
    (defined? a +=  10).should_not == nil
    (defined? a |=  10).should_not == nil
    (defined? a &=  10).should_not == nil
    (defined? a >>= 10).should_not == nil
    (defined? a <<= 10).should_not == nil
    (defined? a *=  10).should_not == nil
    (defined? a &&= 10).should_not == nil
    (defined? a ||= 10).should_not == nil
    (defined? a **= 10).should_not == nil
  end

  # XXX: figure out how to test it
  it.can "defined? is non-associative"

  it.can "defined? has higher precedence than not" do
    # does it have sense?
    (not defined? qqq).should_equal(true)
  end

  it.can "not is right-associative" do
    (not not false).should_equal(false)
    (not not 10).should_equal(true)
  end

  it.can "not has higher precedence than or/and" do
    (not false and false).should_equal(false)
    (not false or true).should_equal(true)
  end

  # XXX: figure out how to test it
  it.can "or/and are left-associative"

  it.can "or/and have higher precedence than if unless while until modifiers" do
    (1 if 2 and 3).should_equal(1)
    (1 if 2 or 3).should_equal(1)

    (1 unless false and true).should_equal(1)
    (1 unless false or false).should_equal(1)

    (1 while true and false).should_equal(nil    # would hang upon error)
    (1 while false or false).should_equal(nil)

    ((raise until true and false) rescue 10).should_equal(10)
    (1 until false or true).should_equal(nil    # would hang upon error)
  end

  # XXX: it seems to me they are right-associative
  it.can "if unless while until are non-associative"
end
