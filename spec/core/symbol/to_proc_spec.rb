# require File.dirname(__FILE__) + '/../../spec_helper'

ruby_version_is "1.8.7" do
  describe "Symbol#to_proc" do |it| 
    it.returns "a new Proc" do
      proc = :to_s.to_proc
      proc.should_be_kind_of(Proc)
    end
  
    it.will "send self to arguments passed when calling #call on the proc" do
      obj = mock("Receiving #to_s")
      obj.should_receive(:to_s).and_return("Received #to_s")
      :to_s.to_proc.call(obj).should_equal("Received #to_s")
    end
  end
end