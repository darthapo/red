# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Module#class_variables" do |it| 
  it.returns "an Array with the names of class variables of self and self's ancestors" do
    ModuleSpecs::ClassVars::A.class_variables.should_include("@@a_cvar")
    ModuleSpecs::ClassVars::M.class_variables.should_include("@@m_cvar")
    ModuleSpecs::ClassVars::B.class_variables.should_include("@@a_cvar", "@@b_cvar", "@@m_cvar")
  end

  it.returns "an Array with names of class variables defined in metaclasses" do
    ModuleSpecs::CVars.class_variables.should_include("@@cls", "@@meta")
  end

  it.returns "an Array with names of class variables defined in included modules" do
    c = Class.new { include ModuleSpecs::MVars }
    c.class_variables.should_include("@@mvar")
  end

  it.does_not "return class variables defined in extended modules" do
    c = Class.new
    c.extend ModuleSpecs::MVars
    c.class_variables.should_not include("@@mvar")
  end
end
