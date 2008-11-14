# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/shared/new'

describe "Exception.exception" do |it| 
  it.behaves_like(:exception_new, :exception)
end

describe "Exception" do |it| 
  it.is_a " Class" do
    Exception.should_be_kind_of(Class)
  end

  it.is_a " superclass of NoMemoryError" do
    Exception.should_be_ancestor_of(NoMemoryError)
  end

  it.is_a " superclass of ScriptError" do
    Exception.should_be_ancestor_of(ScriptError)
  end
  
  it.is_a " superclass of SignalException" do
    Exception.should_be_ancestor_of(SignalException)
  end
  
  it.is_a " superclass of Interrupt" do
    SignalException.should_be_ancestor_of(Interrupt)
  end

  it.is_a " superclass of StandardError" do
    Exception.should_be_ancestor_of(StandardError)
  end
  
  it.is_a " superclass of SystemExit" do
    Exception.should_be_ancestor_of(SystemExit)
  end

  it.is_a " superclass of SystemStackError" do
    Exception.should_be_ancestor_of(SystemStackError)
  end
end
