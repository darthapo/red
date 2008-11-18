# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Float#/" do |it| 
  it.returns "self divided by other" do
    (5.75 / -2).should_be_close(-2.875,TOLERANCE)
    (451.0 / 9.3).should_be_close(48.494623655914,TOLERANCE)
    (91.1 / -0xffffffff).should_be_close(-2.12108716418061e-08, TOLERANCE)
  end
  
  it.can "properly handles BigDecimal argument" do
    require 'bigdecimal'
    (2.0 / BigDecimal.new('5.0')).should_be_close(0.4, TOLERANCE)
    (2.0 / BigDecimal.new('Infinity')).should_equal(0)
    (2.0 / BigDecimal.new('-Infinity')).should_equal(0)
    (2.0 / BigDecimal.new('0.0')).infinite?.should_equal(1)
    (2.0 / BigDecimal.new('-0.0')).infinite?.should_equal(-1)
    (2.0 / BigDecimal.new('NaN')).nan?.should_equal(true)
  end
  
  it.does_not "raise ZeroDivisionError if other is zero" do
    (1.0 / 0.0).to_s.should_equal('Infinity')
    (-1.0 / 0.0).to_s.should_equal('-Infinity')
    (1.0 / -0.0).to_s.should_equal('-Infinity')
    (-1.0 / -0.0).to_s.should_equal('Infinity')
    (0.0 / 0.0).to_s.should_equal('NaN')
    (-0.0 / 0.0).to_s.should_equal('NaN')
    (-0.0 / -0.0).to_s.should_equal('NaN')
  end
end
