# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Hash#index" do |it| 
  it.returns "the corresponding key for value" do
    {2 => 'a', 1 => 'b'}.index('b').should_equal(1)
  end

  it.returns "nil if the value is not found" do
    {:a => -1, :b => 3.14, :c => 2.718}.index(1).should_equal(nil)
  end

  it.does_not " return default value if the value is not found" do
    Hash.new(5).index(5).should_equal(nil)
  end

  it.can "compare values using ==" do
    {1 => 0}.index(0.0).should_equal(1)
    {1 => 0.0}.index(0).should_equal(1)

    needle = mock('needle')
    inhash = mock('inhash')
    inhash.should_receive(:==).with(needle).and_return(true)

    {1 => inhash}.index(needle).should_equal(1)
  end
end
