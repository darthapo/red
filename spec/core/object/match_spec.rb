# require File.dirname(__FILE__) + '/../../spec_helper'

describe Object, '=~' do
  it.returns 'false matching any object' do
    o = Object.new

    (o =~ /Object/).should_equal(false)
    (o =~ 'Object').should_equal(false)
    (o =~ Object).should_equal(false)
    (o =~ Object.new).should_equal(false)
    (o =~ nil).should_equal(false)
    (o =~ true).should_equal(false)
  end
end
