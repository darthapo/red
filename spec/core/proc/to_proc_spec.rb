# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Proc#to_proc" do |it| 
  it.returns "self" do
    [Proc.new {}, lambda {}, proc {}].each { |p|
      p.to_proc.should_equal(p)
    }
  end
end
