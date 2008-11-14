# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/methods'

describe "Time#+" do |it| 
  it.will "increment the time by the specified amount" do
    (Time.at(0) + 100).should_equal(Time.at(100))
    (Time.at(1.1) + 0.9).should_equal(Time.at(2))
  end

  it.will "accept arguments that can be coerced into Float" do
    (obj = mock('10.5')).should_receive(:to_f).and_return(10.5)
    (Time.at(100) + obj).should_equal(Time.at(110.5))
  end

  it.raises " TypeError on argument that can't be coerced into Float" do
    lambda { Time.now + Object.new }.should_raise(TypeError)
    lambda { Time.now + "stuff" }.should_raise(TypeError)
  end

  it.raises " TypeError on Time argument" do
    lambda { Time.now + Time.now }.should_raise(TypeError)
  end

  it.raises " TypeError on nil argument" do
    lambda { Time.now + nil }.should_raise(TypeError)
  end
end
