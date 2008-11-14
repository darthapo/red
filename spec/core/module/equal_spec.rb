# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'
# require File.dirname(__FILE__) + '/shared/equal_value'

describe "Module#equal?" do |it| 
  it.behaves_like(:module_equal, :equal?)
end
