# require File.dirname(__FILE__) + '/../../spec_helper'

describe "Regexp#inspect" do |it| 
  it.returns "a formatted string that would eval to the same regexp" do
    /ab+c/ix.inspect.should_equal("/ab+c/ix")
    /a(.)+s/n.inspect.should =~ %r|/a(.)+s/n?|  # Default 'n' may not appear
    /a(.)+s/u.inspect.should_equal("/a(.)+s/u"     # But a specified one does)
  end
  
  it.can "correctly escapes forward slashes /" do
    Regexp.new("/foo/bar").inspect.should_equal("/\\/foo\\/bar/")
    Regexp.new("/foo/bar[/]").inspect.should_equal("/\\/foo\\/bar[\\/]/")
  end  
end
