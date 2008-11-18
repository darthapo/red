# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Float#==" do |it| 
  it.returns "true if self has the same value as other" do
    (1.0 == 1).should_equal(true)
    (2.71828 == 1.428).should_equal(false)
    (-4.2 == 4.2).should_equal(false)
  end

  it.calls " 'other == self' if coercion fails" do
    class X; def ==(other); 2.0 == other; end; end

    (1.0 == X.new).should_equal(false)
    (2.0 == X.new).should_equal(true)
  end
end
