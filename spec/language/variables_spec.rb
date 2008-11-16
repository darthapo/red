# require File.dirname(__FILE__) + '/../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/variables'

describe "Basic assignment" do |it| 
  it.can "allows the rhs to be assigned to the lhs" do
    a = nil;       a.should_equal(nil)
    a = 1;         a.should_equal(1)
    a = [];        a.should_equal([])
    a = [1];       a.should_equal([1])
    a = [nil];     a.should_equal([nil])
    a = [[]];      a.should_equal([[]])
    a = [1,2];     a.should_equal([1,2])
    a = [*[]];     a.should_equal([])
    a = [*[1]];    a.should_equal([1])
    a = [*[1,2]];  a.should_equal([1, 2])
  end

  it.can "assigns nil to lhs when rhs is an empty expression" do
    a = ()
    a.should_be_nil

    a = *()
    a.should_be_nil
  end

  it.can "allows the assignment of the rhs to the lhs using the rhs splat operator" do
    a = *nil;      a.should_equal(nil)
    a = *1;        a.should_equal(1)
    a = *[];       a.should_equal(nil)
    a = *[1];      a.should_equal(1)
    a = *[nil];    a.should_equal(nil)
    a = *[[]];     a.should_equal([])
    a = *[1,2];    a.should_equal([1,2])
    a = *[*[]];    a.should_equal(nil)
    a = *[*[1]];   a.should_equal(1)
    a = *[*[1,2]]; a.should_equal([1,2])
  end

  it.can "allows the assignment of the rhs to the lhs using the lhs splat operator" do
    * = 1,2        # Valid syntax, but pretty useless! Nothing to test
    *a = nil;      a.should_equal([nil])
    *a = 1;        a.should_equal([1])
    *a = [];       a.should_equal([[]])
    *a = [1];      a.should_equal([[1]])
    *a = [nil];    a.should_equal([[nil]])
    *a = [[]];     a.should_equal([[[]]])
    *a = [1,2];    a.should_equal([[1,2]])
    *a = [*[]];    a.should_equal([[]])
    *a = [*[1]];   a.should_equal([[1]])
    *a = [*[1,2]]; a.should_equal([[1,2]])
  end
  
  it.can "allows the assignment of rhs to the lhs using the lhs and rhs splat operators simultaneously" do
    *a = *nil;      a.should_equal([nil])
    *a = *1;        a.should_equal([1])
    *a = *[];       a.should_equal([])
    *a = *[1];      a.should_equal([1])
    *a = *[nil];    a.should_equal([nil])
    *a = *[[]];     a.should_equal([[]])
    *a = *[1,2];    a.should_equal([1,2])
    *a = *[*[]];    a.should_equal([])
    *a = *[*[1]];   a.should_equal([1])
    *a = *[*[1,2]]; a.should_equal([1,2])
  end

  it.can "allows multiple values to be assigned" do
    a,b,*c = nil;       [a,b,c].should_equal([nil, nil, []])
    a,b,*c = 1;         [a,b,c].should_equal([1, nil, []])
    a,b,*c = [];        [a,b,c].should_equal([nil, nil, []])
    a,b,*c = [1];       [a,b,c].should_equal([1, nil, []])
    a,b,*c = [nil];     [a,b,c].should_equal([nil, nil, []])
    a,b,*c = [[]];      [a,b,c].should_equal([[], nil, []])
    a,b,*c = [1,2];     [a,b,c].should_equal([1,2,[]])
    a,b,*c = [*[]];     [a,b,c].should_equal([nil, nil, []])
    a,b,*c = [*[1]];    [a,b,c].should_equal([1, nil, []])
    a,b,*c = [*[1,2]];  [a,b,c].should_equal([1, 2, []])
    
    a,b,*c = *nil;      [a,b,c].should_equal([nil, nil, []])
    a,b,*c = *1;        [a,b,c].should_equal([1, nil, []])
    a,b,*c = *[];       [a,b,c].should_equal([nil, nil, []])
    a,b,*c = *[1];      [a,b,c].should_equal([1, nil, []])
    a,b,*c = *[nil];    [a,b,c].should_equal([nil, nil, []])
    a,b,*c = *[[]];     [a,b,c].should_equal([[], nil, []])
    a,b,*c = *[1,2];    [a,b,c].should_equal([1,2,[]])
    a,b,*c = *[*[]];    [a,b,c].should_equal([nil, nil, []])
    a,b,*c = *[*[1]];   [a,b,c].should_equal([1, nil, []])
    a,b,*c = *[*[1,2]]; [a,b,c].should_equal([1, 2, []])
  end
  
  it.supports "the {|r,| } form of block assignment" do
    f = lambda {|r,| r.should_equal([]})
    f.call([], *[])   
    
    f = lambda{|x,| x}
    f.call(42).should_equal(42)
    f.call([42]).should_equal([42])
    f.call([[42]]).should_equal([[42]])
    f.call([42,55]).should_equal([42,55]     )
  end
  
  it.can "allows assignment through lambda" do
    f = lambda {|r,*l| r.should_equal([]; l.should == [1]})
    f.call([], *[1])

    f = lambda{|x| x}
    f.call(42).should_equal(42)
    f.call([42]).should_equal([42])
    f.call([[42]]).should_equal([[42]])
    f.call([42,55]).should_equal([42,55])

    f = lambda{|*x| x}
    f.call(42).should_equal([42])
    f.call([42]).should_equal([[42]])
    f.call([[42]]).should_equal([[[42]]])
    f.call([42,55]).should_equal([[42,55]])
    f.call(42,55).should_equal([42,55])
  end
  
  it.can "allows chained assignment" do
    (a = 1 + b = 2 + c = 4 + d = 8).should_equal(15)
    d.should_equal(8)
    c.should_equal(12)
    b.should_equal(14)
    a.should_equal(15)
  end
end

describe "Assignment using expansion" do |it| 
  it.can "succeeds without conversion" do
    *x = (1..7).to_a
    x.should_equal([[1, 2, 3, 4, 5, 6, 7]])
  end
end

describe "Assigning multiple values" do |it| 
  it.can "allows parallel assignment" do
    a, b = 1, 2
    a.should_equal(1)
    b.should_equal(2)

    a, = 1,2
    a.should_equal(1)
  end
  
  it.can "allows safe parallel swapping" do
    a, b = 1, 2
    a, b = b, a
    a.should_equal(2)
    b.should_equal(1)
  end

  it.can "evaluates rhs left-to-right" do
    a = VariablesSpecs::ParAsgn.new
    d,e,f = a.inc, a.inc, a.inc
    d.should_equal(1)
    e.should_equal(2)
    f.should_equal(3)
  end

  it.supports "parallel assignment to lhs args via object.method=" do
    a = VariablesSpecs::ParAsgn.new
    a.x,b = 1,2
    a.x.should_equal(1)
    b.should_equal(2)

    c = VariablesSpecs::ParAsgn.new
    c.x,a.x = a.x,b
    c.x.should_equal(1)
    a.x.should_equal(2 )
  end

  it.supports "parallel assignment to lhs args using []=" do
    a = [1,2,3]
    a[3],b = 4,5
    a.should_equal([1,2,3,4])
    b.should_equal(5)
  end

  it.can "bundles remaining values to an array when using the splat operator" do
    a, *b = 1, 2, 3
    a.should_equal(1)
    b.should_equal([2, 3])
    
    *a = 1, 2, 3
    a.should_equal([1, 2, 3])
    
    *a = 4
    a.should_equal([4])
    
    *a = nil
    a.should_equal([nil])
    
    a,=*[1]
    a.should_equal(1)
    a,=*[[1]]
    a.should_equal([1])
    a,=*[[[1]]]
    a.should_equal([[1]])
  end

  it.calls " #to_ary on rhs arg if rhs has only a single arg" do
    x = VariablesSpecs::ParAsgn.new
    a,b,c = x
    a.should_equal(1)
    b.should_equal(2)
    c.should_equal(3)

    a,b,c = x,5
    a.should_equal(x)
    b.should_equal(5)
    c.should_equal(nil)

    a,b,c = 5,x
    a.should_equal(5)
    b.should_equal(x)
    c.should_equal(nil)

    a,b,*c = x,5
    a.should_equal(x)
    b.should_equal(5)
    c.should_equal([])

    a,(*b),c = 5,x
    a.should_equal(5)
    b.should_equal([x])
    c.should_equal(nil)

    a,(b,c) = 5,x
    a.should_equal(5)
    b.should_equal(1)
    c.should_equal(2)

    a,(b,*c) = 5,x
    a.should_equal(5)
    b.should_equal(1)
    c.should_equal([2,3,4])

    a,(b,(*c)) = 5,x
    a.should_equal(5)
    b.should_equal(1)
    c.should_equal([2])

    a,(b,(*c),(*d)) = 5,x
    a.should_equal(5)
    b.should_equal(1)
    c.should_equal([2])
    d.should_equal([3])

    a,(b,(*c),(d,*e)) = 5,x
    a.should_equal(5)
    b.should_equal(1)
    c.should_equal([2])
    d.should_equal(3)
    e.should_equal([])
  end
    
  it.can "allows complex parallel assignment" do
    a, (b, c), d = 1, [2, 3], 4
    a.should_equal(1)
    b.should_equal(2)
    c.should_equal(3)
    d.should_equal(4)
    
    x, (y, z) = 1, 2, 3
    [x,y,z].should_equal([1,2,nil])
    x, (y, z) = 1, [2,3]
    [x,y,z].should_equal([1,2,3])
    x, (y, z) = 1, [2]
    [x,y,z].should_equal([1,2,nil])

    a,(b,c,*d),(e,f),*g = 0,[1,2,3,4],[5,6],7,8
    a.should_equal(0)
    b.should_equal(1)
    c.should_equal(2)
    d.should_equal([3,4])
    e.should_equal(5)
    f.should_equal(6)
    g.should_equal([7,8])

    x = VariablesSpecs::ParAsgn.new
    a,(b,c,*d),(e,f),*g = 0,x,[5,6],7,8
    a.should_equal(0)
    b.should_equal(1)
    c.should_equal(2)
    d.should_equal([3,4])
    e.should_equal(5)
    f.should_equal(6)
    g.should_equal([7,8])
  end

  it.can "allows a lhs arg to be used in another lhs args parallel assignment" do
    c = [4,5,6]
    a,b,c[a] = 1,2,3
    a.should_equal(1)
    b.should_equal(2)
    c.should_equal([4,3,6])

    c[a],b,a = 7,8,9
    a.should_equal(9)
    b.should_equal(8)
    c.should_equal([4,7,6])
  end
end

describe "Conditional assignment" do |it| 
  it.can "assigns the lhs if previously unassigned" do
    a=[]
    a[0] ||= "bar"
    a[0].should_equal("bar")

    h={}
    h["foo"] ||= "bar"
    h["foo"].should_equal("bar")

    h["foo".to_sym] ||= "bar"
    h["foo".to_sym].should_equal("bar")

    aa = 5
    aa ||= 25
    aa.should_equal(5)

    bb ||= 25
    bb.should_equal(25)

    cc &&=33
    cc.should_equal(nil)

    cc = 5
    cc &&=44
    cc.should_equal(44)
  end

  it.checks "for class variable definition before fetching its value" do
    class VariableSpecCVarSpec
      @@cvarspec ||= 5
      @@cvarspec.should_equal(5)
    end
  end
end

describe "Operator assignment 'var op= expr'" do |it| 
  it.is "equivalent to 'var = var op expr'" do
    x = 13
    (x += 5).should_equal(18)
    x.should_equal(18)

    x = 17
    (x -= 11).should_equal(6)
    x.should_equal(6)

    x = 2
    (x *= 5).should_equal(10)
    x.should_equal(10)

    x = 36
    (x /= 9).should_equal(4)
    x.should_equal(4)

    x = 23
    (x %= 5).should_equal(3)
    x.should_equal(3)
    (x %= 3).should_equal(0)
    x.should_equal(0)

    x = 2
    (x **= 3).should_equal(8)
    x.should_equal(8)

    x = 4
    (x |= 3).should_equal(7)
    x.should_equal(7)
    (x |= 4).should_equal(7)
    x.should_equal(7)

    x = 6
    (x &= 3).should_equal(2)
    x.should_equal(2)
    (x &= 4).should_equal(0)
    x.should_equal(0)

    # XOR
    x = 2
    (x ^= 3).should_equal(1)
    x.should_equal(1)
    (x ^= 4).should_equal(5)
    x.should_equal(5)

    # Bit-shift left
    x = 17
    (x <<= 3).should_equal(136)
    x.should_equal(136)

    # Bit-shift right
    x = 5
    (x >>= 1).should_equal(2)
    x.should_equal(2)

    x = nil
    (x ||= 17).should_equal(17)
    x.should_equal(17)
    (x ||= 2).should_equal(17)
    x.should_equal(17)

    x = false
    (x &&= true).should_equal(false)
    x.should_equal(false)
    (x &&= false).should_equal(false)
    x.should_equal(false)
    x = true
    (x &&= true).should_equal(true)
    x.should_equal(true)
    (x &&= false).should_equal(false)
    x.should_equal(false)
  end
  
  it.can "uses short-circuit arg evaluation for operators ||= and &&=" do
    x = 8
    y = VariablesSpecs::OpAsgn.new
    (x ||= y.do_side_effect).should_equal(8)
    y.side_effect.should_equal(nil)
    
    x = nil
    (x &&= y.do_side_effect).should_equal(nil)
    y.side_effect.should_equal(nil)

    y.a = 5
    (x ||= y.do_side_effect).should_equal(5)
    y.side_effect.should_equal(true)
  end
end

describe "Operator assignment 'obj.meth op= expr'" do |it| 
  it.is "equivalent to 'obj.meth = obj.meth op expr'" do
    @x = VariablesSpecs::OpAsgn.new
    @x.a = 13
    (@x.a += 5).should_equal(18)
    @x.a.should_equal(18)

    @x.a = 17
    (@x.a -= 11).should_equal(6)
    @x.a.should_equal(6)

    @x.a = 2
    (@x.a *= 5).should_equal(10)
    @x.a.should_equal(10)

    @x.a = 36
    (@x.a /= 9).should_equal(4)
    @x.a.should_equal(4)

    @x.a = 23
    (@x.a %= 5).should_equal(3)
    @x.a.should_equal(3)
    (@x.a %= 3).should_equal(0)
    @x.a.should_equal(0)

    @x.a = 2
    (@x.a **= 3).should_equal(8)
    @x.a.should_equal(8)

    @x.a = 4
    (@x.a |= 3).should_equal(7)
    @x.a.should_equal(7)
    (@x.a |= 4).should_equal(7)
    @x.a.should_equal(7)

    @x.a = 6
    (@x.a &= 3).should_equal(2)
    @x.a.should_equal(2)
    (@x.a &= 4).should_equal(0)
    @x.a.should_equal(0)

    # XOR
    @x.a = 2
    (@x.a ^= 3).should_equal(1)
    @x.a.should_equal(1)
    (@x.a ^= 4).should_equal(5)
    @x.a.should_equal(5)

    @x.a = 17
    (@x.a <<= 3).should_equal(136)
    @x.a.should_equal(136)

    @x.a = 5
    (@x.a >>= 1).should_equal(2)
    @x.a.should_equal(2)

    @x.a = nil
     (@x.a ||= 17).should_equal(17)
    @x.a.should_equal(17)
    (@x.a ||= 2).should_equal(17)
    @x.a.should_equal(17)

    @x.a = false
    (@x.a &&= true).should_equal(false)
    @x.a.should_equal(false)
    (@x.a &&= false).should_equal(false)
    @x.a.should_equal(false)
    @x.a = true
    (@x.a &&= true).should_equal(true)
    @x.a.should_equal(true)
    (@x.a &&= false).should_equal(false)
    @x.a.should_equal(false)
  end
  
  it.can "uses short-circuit arg evaluation for operators ||= and &&=" do
    x = 8
    y = VariablesSpecs::OpAsgn.new
    (x ||= y.do_side_effect).should_equal(8)
    y.side_effect.should_equal(nil)
    
    x = nil
    (x &&= y.do_side_effect).should_equal(nil)
    y.side_effect.should_equal(nil)

    y.a = 5
    (x ||= y.do_side_effect).should_equal(5)
    y.side_effect.should_equal(true)
  end

  it.can "evaluates lhs one time" do
    x = VariablesSpecs::OpAsgn.new
    x.a = 5
    (x.do_more_side_effects.a += 5).should_equal(15)
    x.a.should_equal(15)

    x.a = 5 
    (x.do_more_side_effects.a -= 4).should_equal(6)
    x.a.should_equal(6)

    x.a = 2
    (x.do_more_side_effects.a *= 5).should_equal(35)
    x.a.should_equal(35)

    x.a = 31
    (x.do_more_side_effects.a /= 9).should_equal(4)
    x.a.should_equal(4)

    x.a = 18
    (x.do_more_side_effects.a %= 5).should_equal(3)
    x.a.should_equal(3)

    x.a = 0
    (x.do_more_side_effects.a **= 3).should_equal(125)
    x.a.should_equal(125)

    x.a = -1
    (x.do_more_side_effects.a |= 3).should_equal(7)
    x.a.should_equal(7)

    x.a = 1
    (x.do_more_side_effects.a &= 3).should_equal(2)
    x.a.should_equal(2)

    # XOR
    x.a = -3
    (x.do_more_side_effects.a ^= 3).should_equal(1)
    x.a.should_equal(1)

    x.a = 12
    (x.do_more_side_effects.a <<= 3).should_equal(136)
    x.a.should_equal(136)

    x.a = 0
    (x.do_more_side_effects.a >>= 1).should_equal(2)
    x.a.should_equal(2)

    x.a = nil
    x.b = 0
    (x.do_bool_side_effects.a ||= 17).should_equal(17)
    x.a.should_equal(17)
    x.b.should_equal(1)

    x.a = false
    x.b = 0
    (x.do_bool_side_effects.a &&= true).should_equal(false)
    x.a.should_equal(false)
    x.b.should_equal(1)
    (x.do_bool_side_effects.a &&= false).should_equal(false)
    x.a.should_equal(false)
    x.b.should_equal(2)
    x.a = true
    x.b = 0
    (x.do_bool_side_effects.a &&= true).should_equal(true)
    x.a.should_equal(true)
    x.b.should_equal(1)
    (x.do_bool_side_effects.a &&= false).should_equal(false)
    x.a.should_equal(false  )
    x.b.should_equal(2)
  end
end

describe "Operator assignment 'obj[idx] op= expr'" do |it| 
  it.is "equivalent to 'obj[idx] = obj[idx] op expr'" do
    x = [2,13,7]
    (x[1] += 5).should_equal(18)
    x.should_equal([2,18,7])

    x = [17,6]
    (x[0] -= 11).should_equal(6)
    x.should_equal([6,6])

    x = [nil,2,28]
    (x[2] *= 2).should_equal(56)
    x.should_equal([nil,2,56])

    x = [3,9,36]
    (x[2] /= x[1]).should_equal(4)
    x.should_equal([3,9,4])

    x = [23,4]
    (x[0] %= 5).should_equal(3)
    x.should_equal([3,4])
    (x[0] %= 3).should_equal(0)
    x.should_equal([0,4])

    x = [1,2,3]
    (x[1] **= 3).should_equal(8)
    x.should_equal([1,8,3])

    x = [4,5,nil]
    (x[0] |= 3).should_equal(7)
    x.should_equal([7,5,nil])
    (x[0] |= 4).should_equal(7)
    x.should_equal([7,5,nil])

    x = [3,6,9]
    (x[1] &= 3).should_equal(2)
    x.should_equal([3,2,9])
    (x[1] &= 4).should_equal(0)
    x.should_equal([3,0,9])

    # XOR
    x = [0,1,2]
    (x[2] ^= 3).should_equal(1)
    x.should_equal([0,1,1])
    (x[2] ^= 4).should_equal(5)
    x.should_equal([0,1,5])

    x = [17]
    (x[0] <<= 3).should_equal(136)
    x.should_equal([136])

    x = [nil,5,8]
    (x[1] >>= 1).should_equal(2)
    x.should_equal([nil,2,8])

    x = [1,nil,12]
    (x[1] ||= 17).should_equal(17)
    x.should_equal([1,17,12])
    (x[1] ||= 2).should_equal(17)
    x.should_equal([1,17,12])
  
    x = [true, false, false]
    (x[1] &&= true).should_equal(false)
    x.should_equal([true, false, false])
    (x[1] &&= false).should_equal(false)
    x.should_equal([true, false, false])
    (x[0] &&= true).should_equal(true)
    x.should_equal([true, false, false])
    (x[0] &&= false).should_equal(false)
    x.should_equal([false, false, false])
  end

  it.can "uses short-circuit arg evaluation for operators ||= and &&=" do
    x = 8
    y = VariablesSpecs::OpAsgn.new
    (x ||= y.do_side_effect).should_equal(8)
    y.side_effect.should_equal(nil)
    
    x = nil
    (x &&= y.do_side_effect).should_equal(nil)
    y.side_effect.should_equal(nil)

    y.a = 5
    (x ||= y.do_side_effect).should_equal(5)
    y.side_effect.should_equal(true)
  end

  it.can "handle complex index (idx) arguments" do
    x = [1,2,3,4]
    (x[0,2] += [5]).should_equal([1,2,5])
    x.should_equal([1,2,5,3,4])
    (x[0,2] += [3,4]).should_equal([1,2,3,4])
    x.should_equal([1,2,3,4,5,3,4])
    
    (x[2..3] += [8]).should_equal([3,4,8])
    x.should_equal([1,2,3,4,8,5,3,4])
    
    y = VariablesSpecs::OpAsgn.new
    y.a = 1
    (x[y.do_side_effect] *= 2).should_equal(4)
    x.should_equal([1,4,3,4,8,5,3,4])
    
    h = {'key1' => 23, 'key2' => 'val'}
    (h['key1'] %= 5).should_equal(3)
    (h['key2'] += 'ue').should_equal('value')
    h.should_equal({'key1' => 3, 'key2' => 'value'})
  end

  it.returns "result of rhs not result of []=" do
    a = VariablesSpecs::Hashalike.new

    (a[123] =   2).should_equal(2)
    (a[123] +=  2).should_equal(125)
    (a[123] -=  2).should_equal(121)
    (a[123] *=  2).should_equal(246)
    # Guard against the Mathn library
    # TODO: Make these specs not rely on specific behaviour / result values
    # by using mocks.
    conflicts_with :Prime do
      (a[123] /=  2).should_equal(61)
    end
    (a[123] %=  2).should_equal(1)
    (a[123] **= 2).should_equal(15129)
    (a[123] |=  2).should_equal(123)
    (a[123] &=  2).should_equal(2)
    (a[123] ^=  2).should_equal(121)
    (a[123] <<= 2).should_equal(492)
    (a[123] >>= 2).should_equal(30)
    (a[123] ||= 2).should_equal(123)
    (a[nil] ||= 2).should_equal(2)
    (a[123] &&= 2).should_equal(2)
    (a[nil] &&= 2).should_equal(nil)
  end
end

describe "Single assignment" do |it| 
  it.can "Assignment does not modify the lhs, it reassigns its reference" do
    a = 'Foobar'
    b = a
    b = 'Bazquux'
    a.should_equal('Foobar')
    b.should_equal('Bazquux')
  end

  it.can "Assignment does not copy the object being assigned, just creates a new reference to it" do
    a = []
    b = a
    b << 1
    a.should_equal([1])
  end

  it.can "If rhs has multiple arguments, lhs becomes an Array of them" do
    a = 1, 2, 3
    a.should_equal([1, 2, 3])

    a = 1, (), 3
    a.should_equal([1, nil, 3])
  end
end

describe "Multiple assignment without grouping or splatting" do |it| 
  it.can "An equal number of arguments on lhs and rhs assigns positionally" do
    a, b, c, d = 1, 2, 3, 4
    a.should_equal(1)
    b.should_equal(2)
    c.should_equal(3)
    d.should_equal(4)
  end 

  it.can "If rhs has too few arguments, the missing ones on lhs are assigned nil" do
    a, b, c = 1, 2
    a.should_equal(1)
    b.should_equal(2)
    c.should_equal(nil)
  end

  it.can "If rhs has too many arguments, the extra ones are silently not assigned anywhere" do
    a, b = 1, 2, 3
    a.should_equal(1)
    b.should_equal(2)
  end

  it.can "The assignments are done in parallel so that lhs and rhs are independent of eachother without copying" do
    o_of_a, o_of_b = mock('a'), mock('b')
    a, b = o_of_a, o_of_b
    a, b = b, a
    a.should_equal(o_of_b)
    b.should_equal(o_of_a)
  end
end

describe "Multiple assignments with splats" do |it| 
  # TODO make this normal once rubinius eval works
  compliant_on :ruby do
    it.can "* on the lhs has to be applied to the last parameter" do
      lambda { eval 'a, *b, c = 1, 2, 3' }.should_raise(SyntaxError)
    end
  end

  it.can "* on the lhs collects all parameters from its position onwards as an Array or an empty Array" do
    a, *b = 1, 2
    c, *d = 1
    e, *f = 1, 2, 3
    g, *h = 1, [2, 3]
    *i = 1, [2,3]
    *j = [1,2,3]
    *k = 1,2,3

    a.should_equal(1)
    b.should_equal([2])
    c.should_equal(1)
    d.should_equal([])
    e.should_equal(1)
    f.should_equal([2, 3])
    g.should_equal(1)
    h.should_equal([[2, 3]])
    i.should_equal([1, [2, 3]])
    j.should_equal([[1,2,3]])
    k.should_equal([1,2,3])
  end
end

describe "Multiple assignments with grouping" do |it| 
  it.can "A group on the lhs is considered one position and treats its corresponding rhs position like an Array" do
    a, (b, c), d = 1, 2, 3, 4
    e, (f, g), h = 1, [2, 3, 4], 5
    i, (j, k), l = 1, 2, 3
    a.should_equal(1)
    b.should_equal(2)
    c.should_equal(nil)
    d.should_equal(3)
    e.should_equal(1)
    f.should_equal(2)
    g.should_equal(3)
    h.should_equal(5)
    i.should_equal(1)
    j.should_equal(2)
    k.should_equal(nil)
    l.should_equal(3)
  end

  it.supports "multiple levels of nested groupings" do
    a,(b,(c,d)) = 1,[2,[3,4]]
    a.should_equal(1)
    b.should_equal(2)
    c.should_equal(3)
    d.should_equal(4)

    a,(b,(c,d)) = [1,[2,[3,4]]]
    a.should_equal(1)
    b.should_equal(2)
    c.should_equal(3)
    d.should_equal(4)

    x = [1,[2,[3,4]]]
    a,(b,(c,d)) = x
    a.should_equal(1)
    b.should_equal(2)
    c.should_equal(3)
    d.should_equal(4)
  end

  compliant_on :ruby do
    it.can "rhs cannot use parameter grouping, it is a syntax error" do
      lambda { eval '(a, b) = (1, 2)' }.should_raise(SyntaxError)
    end
  end
end

compliant_on :ruby do

describe "Multiple assignment" do |it| 
  it.can "has the proper return value" do
    (a,b,*c = *[5,6,7,8,9,10]).should_equal([5,6,7,8,9,10])
    (d,e = VariablesSpecs.reverse_foo(4,3)).should_equal([3,4])
    (f,g,h = VariablesSpecs.reverse_foo(6,7)).should_equal([7,6])
    (i,*j = *[5,6,7]).should_equal([5,6,7])
    (k,*l = [5,6,7]).should_equal([5,6,7])
    a.should_equal(5)
    b.should_equal(6)
    c.should_equal([7,8,9,10])
    d.should_equal(3)
    e.should_equal(4)
    f.should_equal(7)
    g.should_equal(6)
    h.should_equal(nil)
    i.should_equal(5)
    j.should_equal([6,7])
    k.should_equal(5)
    l.should_equal([6,7])
  end
end
end

# For now, masgn is deliberately non-compliant with MRI wrt the return val from an masgn.
# Rubinius returns true as the result of the assignment, but MRI returns an array
# containing all the elements on the rhs. As this result is never used, the cost
# of creating and then discarding this array is avoided
describe "Multiple assignment, array-style" do |it| 
  compliant_on :ruby do
    it.returns "an array of all rhs values" do
      (a,b = 5,6,7).should_equal([5,6,7])
      a.should_equal(5)
      b.should_equal(6)

      (c,d,*e = 99,8).should_equal([99,8])
      c.should_equal(99)
      d.should_equal(8)
      e.should_equal([])

      (f,g,h = 99,8).should_equal([99,8])
      f.should_equal(99)
      g.should_equal(8)
      h.should_equal(nil)
    end
  end

  deviates_on :rubinius do
    it.returns "true" do
      (a,b = 5,6,7).should_equal(true)
      a.should_equal(5)
      b.should_equal(6)

      (c,d,*e = 99,8).should_equal(true)
      c.should_equal(99)
      d.should_equal(8)
      e.should_equal([])

      (f,g,h = 99,8).should_equal(true)
      f.should_equal(99)
      g.should_equal(8)
      h.should_equal(nil)
    end
  end
end

describe "Scope of variables" do |it| 
  it.can "instance variables not overwritten by local variable in each block" do
    
    class ScopeVariables
      attr_accessor :v

      def initialize
        @v = ['a', 'b', 'c']
      end

      def check_access
        v.should_equal(['a', 'b', 'c'])
        self.v.should_equal(['a', 'b', 'c'])
      end
      
      def check_local_variable
        v = nil
        self.v.should_equal(['a', 'b', 'c'])
      end
      
      def check_each_block
        self.v.each { |v|
          # Don't actually do anything
        }
        self.v.should_equal(['a', 'b', 'c'])
        v.should_equal(['a', 'b', 'c'])
        self.v.object_id.should_equal(v.object_id)
      end
    end # Class ScopeVariables
    
    instance = ScopeVariables.new()
    instance.check_access
    instance.check_local_variable
    instance.check_each_block
  end
end
