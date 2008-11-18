# require File.dirname(__FILE__) + '/../spec_helper'

module LangModuleSpec
  module Sub1; end
end

module LangModuleSpec::Sub2; end

describe "module" do |it| 
  it.can "has the right name" do
    LangModuleSpec::Sub1.name.should_equal("LangModuleSpec::Sub1")
    LangModuleSpec::Sub2.name.should_equal("LangModuleSpec::Sub2")
  end

  it.can "gets a name when assigned to a constant" do
    m = Module.new
    LangModuleSpec::Anon = Module.new

    m.name.should_equal("")
    LangModuleSpec::Anon.name.should_equal("LangModuleSpec::Anon")
  end
end
