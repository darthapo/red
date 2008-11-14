# This file specifies behaviour for the methods of
# Continuation. The mechanics thereof may be further
# examined in spec/language.
#
# require File.dirname(__FILE__) + '/../../spec_helper'

# Class methods
#   -
#
# Instance methods
#   #call             OK
#   #[]               OK


describe "Creating a Continuation object" do |it| 
  not_supported_on :jruby,:ir do
    it.can "must be done through Kernel.callcc, no .new" do
      lambda { Continuation.new }.should_raise(NoMethodError)

      Kernel.callcc {|@cc|}
      c = @cc
      c.class.should_equal(Continuation)
    end
  end
end


describe "Executing a Continuation" do |it| 
  not_supported_on :jruby,:ir do
    it.can "using #call transfers execution to right after the Kernel.callcc block" do
      array = [:reached, :not_reached]

      Kernel.callcc {|@cc|}
    
      unless array.first == :not_reached
        array.shift
        @cc.call
      end

      array.should_equal([:not_reached])
    end

    it.can "arguments given to #call (or nil) are returned by the Kernel.callcc block (as Array unless only one object)" do
      Kernel.callcc {|cc| cc.call}.should_equal(nil )
      Kernel.callcc {|cc| cc.call 1}.should_equal(1 )
      Kernel.callcc {|cc| cc.call 1, 2, 3}.should_equal([1, 2, 3] )
    end

    it.can "#[] is an alias for #call" do
      Kernel.callcc {|cc| cc.call}.should_equal(Kernel.callcc {|cc| cc[]})
      Kernel.callcc {|cc| cc.call 1}.should_equal(Kernel.callcc {|cc| cc[1]})
      Kernel.callcc {|cc| cc.call 1, 2, 3}.should_equal(Kernel.callcc {|cc| cc[1, 2, 3]} )
    end
  end
end
