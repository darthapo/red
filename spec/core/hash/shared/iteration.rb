describe :hash_iteration_method, :shared => true do
  # These are the only ones that actually have the exceptions on MRI 1.8.
  # sort and reject don't raise!
  # 
  #   delete_if each each_key each_pair each_value merge merge! reject!
  #   select update
  #
  hsh = {1 => 2, 3 => 4, 5 => 6}  
  big_hash = {}
  64.times { |k| big_hash[k.to_s] = k }    
     
  # it.raises " a RuntimeError if #rehash is called from block" do
  #   h = hsh.dup
  #   args = @method.to_s[/merge|update/] ? [h] : []
  #   
  #   lambda {
  #     h.send(@method, *args) { h.rehash }
  #   }.should_raise(RuntimeError)
  # end
  # 
  # # This specification seems arbitrary, but describes the behavior of MRI
  # it.raises " if more than 63 new entries are added from block" do
  #   h = hsh.dup
  #   args = @method.to_s[/merge|update/] ? [h] : []
  # 
  #   lambda {
  #     h.send(@method, *args) { |*x| h.merge!(big_hash) }
  #   }.should_raise(RuntimeError)
  # end

end

describe :hash_iteration_modifying, :shared => true do
  hsh = {1 => 2, 3 => 4, 5 => 6}  
  big_hash = {}
  100.times { |k| big_hash[k.to_s] = k }    
     
  it.does_not "affect yielded items by removing the current element" do
    n = 3
  
    h = Array.new(n) { hsh.dup }
    args = Array.new(n) { |i| @method.to_s[/merge|update/] ? [h[i]] : [] }
    r = Array.new(n) { [] }
  
    h[0].send(@method, *args[0]) { |*x| r[0] << x; true }
    h[1].send(@method, *args[1]) { |*x| r[1] << x; h[1].shift; true }
    h[2].send(@method, *args[2]) { |*x| r[2] << x; h[2].delete(h[2].keys.first); true }
  
    r[1..-1].each do |yielded|
      yielded.should_equal(r[0])
    end
  end
end
