# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Array#nitems" do |it| 
  it.returns "the number of non-nil elements" do
    [nil].nitems.should_equal(0)
    [].nitems.should_equal(0    )
    [1, 2, 3, nil].nitems.should_equal(3)
    [1, 2, 3].nitems.should_equal(3)
    [1, nil, 2, 3, nil, nil, 4].nitems.should_equal(4)
    [1, nil, 2, false, 3, nil, nil, 4].nitems.should_equal(5)
  end

  it.can "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    empty.nitems.should_equal(1)

    array = ArraySpecs.recursive_array
    array.nitems.should_equal(8)

    [nil, empty, array].nitems.should_equal(2)
  end
end
