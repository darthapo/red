# require File.dirname(__FILE__) + '/../spec_helper'

describe "The if expression" do |it| 
  it.can "evaluates body if expression is true" do
    a = []
    if true
      a << 123
    end
    a.should_equal([123])
  end

  it.does_not "evaluate body if expression is false" do
    a = []
    if false
      a << 123
    end
    a.should_equal([])
  end

  it.does_not "evaluate body if expression is empty" do
    a = []
    if ()
      a << 123
    end
    a.should_equal([])
  end

  it.does_not "evaluate else-body if expression is true" do
    a = []
    if true
      a << 123
    else
      a << 456
    end
    a.should_equal([123])
  end

  it.can "evaluates only else-body if expression is false" do
    a = []
    if false
      a << 123
    else
      a << 456
    end
    a.should_equal([456])
  end

  it.returns "result of then-body evaluation if expression is true" do
    if true
      123
    end.should_equal(123)
  end

  it.returns "result of last statement in then-body if expression is true" do
    if true
      'foo'
      'bar'
      'baz'
    end.should_equal('baz')
  end

  it.returns "result of then-body evaluation if expression is true and else part is present" do
    if true
      123
    else
      456
    end.should_equal(123)
  end

  it.returns "result of else-body evaluation if expression is false" do
    if false
      123
    else
      456
    end.should_equal(456)
  end

  it.returns "nil if then-body is empty and expression is true" do
    if true
    end.should_equal(nil)
  end

  it.returns "nil if then-body is empty, expression is true and else part is present" do
    if true
    else
      456
    end.should_equal(nil)
  end

  it.returns "nil if then-body is empty, expression is true and else part is empty" do
    if true
    else
    end.should_equal(nil)
  end

  it.returns "nil if else-body is empty and expression is false" do
    if false
      123
    else
    end.should_equal(nil)
  end

  it.returns "nil if else-body is empty, expression is false and then-body is empty" do
    if false
    else
    end.should_equal(nil)
  end

  it.can "considers an expression with nil result as false" do
    if nil
      123
    else
      456
    end.should_equal(456)
  end

  it.can "considers a non-nil and non-boolean object in expression result as true" do
    if mock('x')
      123
    else
      456
    end.should_equal(123)
  end

  it.can "considers a zero integer in expression result as true" do
    if 0
      123
    else
      456
    end.should_equal(123)
  end

  it.can "allows starting then-body on the same line if colon is used" do
    if true: 123
    else
      456
    end.should_equal(123)
  end

  it.can "allows starting else-body on the same line" do
    if false
      123
    else 456
    end.should_equal(456)
  end

  it.can "allows both then- and else-bodies start on the same line (with colon after expression)" do
    if false: 123
    else 456
    end.should_equal(456)
  end

  it.can "evaluates subsequent elsif statements and execute body of first matching" do
    if false
      123
    elsif false
      234
    elsif true
      345
    elsif true
      456
    end.should_equal(345)
  end

  it.can "evaluates else-body if no if/elsif statements match" do
    if false
      123
    elsif false
      234
    elsif false
      345
    else
      456
    end.should_equal(456)
  end

  it.can "allows ':' after expression when then-body is on the next line" do
    if true:
      123
    end.should_equal(123)

    if true; 123; end.should_equal(123)
  end

  it.can "allows 'then' after expression when then-body is on the next line" do
    if true then
      123
    end.should_equal(123)

    if true then ; 123; end.should_equal(123)
  end

  it.can "allows then-body on the same line separated with ':'" do
    if true: 123
    end.should_equal(123)

    if true: 123; end.should_equal(123)
  end

  it.can "allows then-body on the same line separated with 'then'" do
    if true then 123
    end.should_equal(123)

    if true then 123; end.should_equal(123)
  end

  it.returns "nil when then-body on the same line separated with ':' and expression is false" do
    if false: 123
    end.should_equal(nil)

    if false: 123; end.should_equal(nil)
  end

  it.returns "nil when then-body on the same line separated with 'then' and expression is false" do
    if false then 123
    end.should_equal(nil)

    if false then 123; end.should_equal(nil)
  end

  it.returns "nil when then-body separated by ':' is empty and expression is true" do
    if true:
    end.should_equal(nil)

    if true: ; end.should_equal(nil)
  end

  it.returns "nil when then-body separated by 'then' is empty and expression is true" do
    if true then
    end.should_equal(nil)

    if true then ; end.should_equal(nil)
  end

  it.returns "nil when then-body separated by ':', expression is false and no else part" do
    if false:
    end.should_equal(nil)

    if false: ; end.should_equal(nil)
  end

  it.returns "nil when then-body separated by 'then', expression is false and no else part" do
    if false then
    end.should_equal(nil)

    if false then ; end.should_equal(nil)
  end

  it.can "evaluates then-body when then-body separated by ':', expression is true and else part is present" do
    if true: 123
    else 456
    end.should_equal(123)

    if true: 123; else 456; end.should_equal(123)
  end

  it.can "evaluates then-body when then-body separated by 'then', expression is true and else part is present" do
    if true then 123
    else 456
    end.should_equal(123)

    if true then 123; else 456; end.should_equal(123)
  end

  it.can "evaluates else-body when then-body separated by ':' and expression is false" do
    if false: 123
    else 456
    end.should_equal(456)

    if false: 123; else 456; end.should_equal(456)
  end

  it.can "evaluates else-body when then-body separated by 'then' and expression is false" do
    if false then 123
    else 456
    end.should_equal(456)

    if false then 123; else 456; end.should_equal(456)
  end

  it.can "allows elsif-body at the same line separated by ':' or 'then'" do
    if false then 123
    elsif false: 234
    elsif true then 345
    elsif true: 456
    end.should_equal(345)

    if false: 123; elsif false then 234; elsif true: 345; elsif true then 456; end.should_equal(345)
  end
end

describe "The postfix if form" do |it| 
  it.can "evaluates statement if expression is true" do
    a = []
    a << 123 if true
    a.should_equal([123])
  end

  it.does_not "evaluate statement if expression is false" do
    a = []
    a << 123 if false
    a.should_equal([])
  end

  it.returns "result of expression if value is true" do
    (123 if true).should_equal(123)
  end

  it.returns "nil if expression is false" do
    (123 if false).should_equal(nil)
  end

  it.can "considers a nil expression as false" do
    (123 if nil).should_equal(nil)
  end

  it.can "considers a non-nil object as true" do
    (123 if mock('x')).should_equal(123)
  end

  it.can "evaluates then-body in containing scope" do
    a = 123
    if true
      b = a+1
    end
    b.should_equal(124)
  end

  it.can "evaluates else-body in containing scope" do
    a = 123
    if false
      b = a+1
    else
      b = a+2
    end
    b.should_equal(125)
  end

  it.can "evaluates elsif-body in containing scope" do
    a = 123
    if false
      b = a+1
    elsif false
      b = a+2
    elsif true
      b = a+3
    else
      b = a+4
    end
    b.should_equal(126)
  end
end
