# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

# src.scan(/[+-]?[\d_]+\.[\d_]+(e[+-]?[\d_]+)?\b|[+-]?[\d_]+e[+-]?[\d_]+\b/i)

describe "String#to_f" do |it| 
  it.will "treat leading characters of self as a floating point number" do
   "123.45e1".to_f.should_equal(1234.5)
   "45.67 degrees".to_f.should_equal(45.67)
   "0".to_f.should_equal(0.0)
   "123.45e1".to_f.should_equal(1234.5)

   ".5".to_f.should_equal(0.5)
   ".5e1".to_f.should_equal(5.0)
  end

  it.will "allow for varying case" do
    "123.45e1".to_f.should_equal(1234.5)
    "123.45E1".to_f.should_equal(1234.5)
  end

  it.will "allow for varying signs" do
    "+123.45e1".to_f.should_equal(+123.45e1)
    "-123.45e1".to_f.should_equal(-123.45e1)
    "123.45e+1".to_f.should_equal(123.45e+1)
    "123.45e-1".to_f.should_equal(123.45e-1)
    "+123.45e+1".to_f.should_equal(+123.45e+1)
    "+123.45e-1".to_f.should_equal(+123.45e-1)
    "-123.45e+1".to_f.should_equal(-123.45e+1)
    "-123.45e-1".to_f.should_equal(-123.45e-1)
  end

  it.will "allow for underscores, even in the decimal side" do
    "1_234_567.890_1".to_f.should_equal(1_234_567.890_1)
  end

  it.returns "0 for strings with any non-digit in them" do
    "blah".to_f.should_equal(0)
    "0b5".to_f.should_equal(0)
    "0d5".to_f.should_equal(0)
    "0o5".to_f.should_equal(0)
    "0xx5".to_f.should_equal(0)
  end

  it.can "take an optional sign" do
    "-45.67 degrees".to_f.should_equal(-45.67)
    "+45.67 degrees".to_f.should_equal(45.67)
    "-5_5e-5_0".to_f.should_equal(-55e-50)
    "-".to_f.should_equal(0.0)
    (1.0 / "-0".to_f).to_s.should_equal("-Infinity")
  end

  it.returns "0.0 if the conversion fails" do
    "bad".to_f.should_equal(0.0)
    "thx1138".to_f.should_equal(0.0)
  end
end
