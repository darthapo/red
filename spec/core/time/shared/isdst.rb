# require File.dirname(__FILE__) + '/../fixtures/methods'

describe :time_isdst, :shared => true do
  it.will "dst? returns whether time is during daylight saving time" do
    with_timezone("America/Los_Angeles") do
      Time.local(2007, 9, 9, 0, 0, 0).send(@method).should_equal(true)
      Time.local(2007, 1, 9, 0, 0, 0).send(@method).should_equal(false)
    end
  end
end
