# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Hash#inspect" do |it| 
  it.returns "a string representation with same order as each()" do
    h = {:a => [1, 2], :b => -2, :d => -6, nil => nil}
    
    pairs = []
    h.each do |key, value|
      pairs << key.inspect + "=>" + value.inspect
    end
    
    str = '{' + pairs.join(', ') + '}'
    h.inspect.should_equal(str)
  end

  it.calls " inspect on keys and values" do
    key = mock('key')
    val = mock('val')
    key.should_receive(:inspect).and_return('key')
    val.should_receive(:inspect).and_return('val')
    
    { key => val }.inspect.should_equal('{key=>val}')
  end

  it.can "handle recursive hashes" do
    x = {}
    x[0] = x
    x.inspect.should_equal('{0=>{...}}')

    x = {}
    x[x] = 0
    x.inspect.should_equal('{{...}=>0}')

    x = {}
    x[x] = x
    x.inspect.should_equal('{{...}=>{...}}')

    x = {}
    y = {}
    x[0] = y
    y[1] = x
    x.inspect.should_equal("{0=>{1=>{...}}}")
    y.inspect.should_equal("{1=>{0=>{...}}}")

    x = {}
    y = {}
    x[y] = 0
    y[x] = 1
    x.inspect.should_equal("{{{...}=>1}=>0}")
    y.inspect.should_equal("{{{...}=>0}=>1}")
    
    x = {}
    y = {}
    x[y] = x
    y[x] = y
    x.inspect.should_equal("{{{...}=>{...}}=>{...}}")
    y.inspect.should_equal("{{{...}=>{...}}=>{...}}")
  end
end
