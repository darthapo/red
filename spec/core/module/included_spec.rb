# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Module#included" do |it| 
  it.is "invoked when self is included in another module or class" do
    begin
      m = Module.new do
        def self.included(o)
          $included_by = o
        end
      end

      c = Class.new { include m }

      $included_by.should_equal(c)
    ensure
      $included_by = nil
    end
  end

  it.will "allow extending self with the object into which it is being included" do
    m = Module.new do
      def self.included(o)
        o.extend(self)
      end

      def test
        :passed
      end
    end

    c = Class.new{ include(m) }
    c.test.should_equal(:passed)
  end
end
