# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Proc as a block pass argument" do |it| 
  def revivify(&b)
    b
  end

  it.can "remain the same object if re-vivified by the target method" do
    p = Proc.new {}
    p2 = revivify(&p)
    p.object_id.should_equal(p2.object_id)
    p.should_equal(p2)
  end

  it.can "remain the same object if reconstructed with Proc.new" do
    p = Proc.new {}
    p2 = Proc.new(&p)
    p.object_id.should_equal(p2.object_id)
    p.should_equal(p2)
  end
end
