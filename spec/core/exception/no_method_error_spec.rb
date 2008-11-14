# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/common'

describe "NoMethodError.new" do |it| 
  it.can "allows passing method args" do
    NoMethodError.new("msg","name","args").args.should_equal("args")
  end
end

describe "NoMethodError#args" do |it| 
  it.returns "an empty array if the caller method had no arguments" do
    begin
      NoMethodErrorSpecs::NoMethodErrorB.new.foo
    rescue Exception => e
      e.args.should_equal([])
    end
  end

  it.returns "an array with the same elements as passed to the method" do
    begin
      a = NoMethodErrorSpecs::NoMethodErrorA.new
      NoMethodErrorSpecs::NoMethodErrorB.new.foo(1,a)
    rescue Exception => e
      e.args.should_equal([1,a])
      e.args[1].object_id.should_equal(a.object_id)
    end
  end
end

describe "NoMethodError#message" do |it| 
  it.can "for an undefined method match /undefined method/" do
    begin
      NoMethodErrorSpecs::NoMethodErrorD.new.foo
    rescue Exception => e
      e.class.should_equal(NoMethodError)
    end
  end

  it.can "for an protected method match /protected method/" do
    begin
      NoMethodErrorSpecs::NoMethodErrorC.new.a_protected_method
    rescue Exception => e
      e.class.should_equal(NoMethodError)
    end
  end

  not_compliant_on :rubinius do
    it.can "for private method match /private method/" do
      begin
        NoMethodErrorSpecs::NoMethodErrorC.new.a_private_method
      rescue Exception => e
        e.class.should_equal(NoMethodError)
        e.message.match(/private method/).should_not == nil
      end
    end
  end
end
