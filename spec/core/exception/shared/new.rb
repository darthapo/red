describe :exception_new, :shared => true do
  it.creates "a new instance of Exception" do
    Exception.should_be_ancestor_of(Exception.send(@method).class)
  end

  it.will "set the message of the Exception when passes a message" do
    Exception.send(@method, "I'm broken.").message.should_equal("I'm broken.")
  end

  it.returns "'Exception' for message when no message given" do
    Exception.send(@method).message.should_equal("Exception")
  end
end
