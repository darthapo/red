# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Symbol#to_sym" do |it| 
  it.returns "self" do
    [:rubinius, :squash, :[], :@ruby, :@@ruby].each do |sym|
      sym.to_sym.should_equal(sym)
    end
  end
end
