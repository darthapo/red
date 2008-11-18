# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/methods'

describe "Time#-" do |it| 
  it.will "decrement the time by the specified amount" do
    (Time.at(100) - 100).should_equal(Time.at(0))
    (Time.at(100) - Time.at(99)).should_equal(1.0)
    (Time.at(1.1) - 0.2).should_equal(Time.at(0.9))
  end

  it.will "accept arguments that can be coerced into Float" do
    (obj = mock('9.5')).should_receive(:to_f).and_return(9.5)
    (Time.at(100) - obj).should_equal(Time.at(90.5)    )
  end

  it.raises " TypeError on argument that can't be coerced into Float" do
    lambda { Time.now - Object.new }.should_raise(TypeError)
    lambda { Time.now - "stuff" }.should_raise(TypeError)
  end

  it.raises " TypeError on nil argument" do
    lambda { Time.now - nil }.should_raise(TypeError)
  end
end
