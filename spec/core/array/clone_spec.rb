# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'
# require File.dirname(__FILE__) + '/shared/clone'

describe "Array#clone" do |it| 
  # it.behaves_like :array_clone, :clone

  it.will "copy singleton methods" do
    a = [1, 2, 3, 4]
    b = [1, 2, 3, 4]
    def a.a_singleton_method; end
    aa = a.clone
    bb = b.clone

    a.respond_to?(:a_singleton_method).should_be_true
    b.respond_to?(:a_singleton_method).should_be_false
    aa.respond_to?(:a_singleton_method).should_be_true
    bb.respond_to?(:a_singleton_method).should_be_false
  end
end
