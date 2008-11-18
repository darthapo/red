# # require File.dirname(__FILE__) + '/shared/collect'

describe "Array#collect" do |it|
  it.behaves_like(:array_collect, :collect)
end

describe "Array#collect!" do |it|
  it.behaves_like(:array_collect_b, :collect!)
end
