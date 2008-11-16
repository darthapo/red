# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'
# require File.dirname(__FILE__) + '/shared/iteration'

describe "Hash#reject" do |it| 
  it.is "equivalent to hsh.dup.delete_if" do
    h = { :a => 'a', :b => 'b', :c => 'd' }
    h.reject { |k,v| k == 'd' }.should_equal((h.dup.delete_if { |k, v| k == 'd' }))
    
    all_args_reject = []
    all_args_delete_if = []
    h = {1 => 2, 3 => 4}
    h.reject { |*args| all_args_reject << args }
    h.delete_if { |*args| all_args_delete_if << args }
    all_args_reject.should_equal(all_args_delete_if)
    
    h = { 1 => 2 }
    # dup doesn't copy singleton methods
    def h.to_a() end
    h.reject { false }.to_a.should_equal([[1, 2]])
  end
  
  it.returns "subclass instance for subclasses" do
    MyHash[1 => 2, 3 => 4].reject { false }.class.should_equal(MyHash)
    MyHash[1 => 2, 3 => 4].reject { true }.class.should_equal(MyHash)
  end
  
  it.can "process entries with the same order as reject!" do
    h = {:a => 1, :b => 2, :c => 3, :d => 4}

    reject_pairs = []
    reject_bang_pairs = []
    h.dup.reject { |*pair| reject_pairs << pair }
    h.reject! { |*pair| reject_bang_pairs << pair }

    reject_pairs.should_equal(reject_bang_pairs)
  end

  it.behaves_like(:hash_iteration_no_block, :reject)
end

describe "Hash#reject!" do |it| 
  it.before(:each) do
    @hsh = {1 => 2, 3 => 4, 5 => 6}
    @empty = {}
  end

  it.is "equivalent to delete_if if changes are made" do
    {:a => 2}.reject! { |k,v| v > 1 }.should_equal(({:a => 2}.delete_if { |k, v| v > 1 }))

    h = {1 => 2, 3 => 4}
    all_args_reject = []
    all_args_delete_if = []
    h.dup.reject! { |*args| all_args_reject << args }
    h.dup.delete_if { |*args| all_args_delete_if << args }
    all_args_reject.should_equal(all_args_delete_if)
  end
  
  it.returns "nil if no changes were made" do
    { :a => 1 }.reject! { |k,v| v > 1 }.should_equal(nil)
  end
  
  it.can "process entries with the same order as delete_if" do
    h = {:a => 1, :b => 2, :c => 3, :d => 4}

    reject_bang_pairs = []
    delete_if_pairs = []
    h.dup.reject! { |*pair| reject_bang_pairs << pair }
    h.dup.delete_if { |*pair| delete_if_pairs << pair }

    reject_bang_pairs.should_equal(delete_if_pairs)
  end  

  it.behaves_like(:hash_iteration_method, :reject!)
end
