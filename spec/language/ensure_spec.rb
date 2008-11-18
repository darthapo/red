# require File.dirname(__FILE__) + '/../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/ensure'

describe "An ensure block inside a begin block" do |it| 
  it.is "executed when an exception is raised in it's corresponding begin block" do
    begin
      executed = []
      
      lambda {
        begin
          executed << :begin
          raise "An exception occured!"
        ensure
          executed << :ensure
        end
      }.should_raise(RuntimeError)
      
      executed.should_equal([:begin, :ensure])
    end
  end

  it.is "executed when an exception is raised and rescued in it's corresponding begin block" do
    begin
      executed = []
      
      begin
        executed << :begin
        raise "An exception occured!"
      rescue
        executed << :rescue
      ensure
        executed << :ensure
      end
      
      executed.should_equal([:begin, :rescue, :ensure])
    end
  end

  it.is "executed even when a symbol is thrown in it's corresponding begin block" do
    begin
      executed = []
      
      catch(:symbol) do
        begin
          executed << :begin
          throw(:symbol)
        rescue
          executed << :rescue
        ensure
          executed << :ensure
        end
      end
      
      executed.should_equal([:begin, :ensure])
    end
  end

  it.is "executed when nothing is raised or thrown in it's corresponding begin block" do
    executed = []
    
    begin
      executed << :begin
      raise "An exception occured!"
    rescue
      executed << :rescue
    ensure
      executed << :ensure
    end
    
    executed.should_equal([:begin, :rescue, :ensure])
  end
  
  it.can "has non return value" do
    begin
      :begin
    ensure
      :ensure
    end.should_equal(:begin)
  end
end

describe "An ensure block inside a method" do |it| 
  it.before(:each) do
    @obj = EnsureSpec::Container.new
  end
  
  it.is "executed when an exception is raised in the method" do
    lambda { @obj.raise_in_method_with_ensure }.should_raise(RuntimeError)
    @obj.executed.should_equal([:method, :ensure])
  end

  it.is "executed when an exception is raised and rescued in the method" do
    @obj.raise_and_rescue_in_method_with_ensure
    @obj.executed.should_equal([:method, :rescue, :ensure])
  end
  
  it.is "executed even when a symbol is thrown in the method" do
    catch(:symbol) { @obj.throw_in_method_with_ensure }
    @obj.executed.should_equal([:method, :ensure])
  end
  
  it.can "has no impact on the method's implicit return value" do
    @obj.implicit_return_in_method_with_ensure.should_equal(:method)
  end
  
  it.can "has an impact on the method's explicit return value" do
    @obj.explicit_return_in_method_with_ensure.should_equal(:ensure)
  end
end