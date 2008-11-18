# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#crypt" do |it| 
  # Note: MRI's documentation just says that the C stdlib function crypt() is
  # called.
  #
  # I'm not sure if crypt() is guaranteed to produce the same result across
  # different platforms. It seems that there is one standard UNIX implementation
  # of crypt(), but that alternative implementations are possible. See
  # http://www.unix.org.ua/orelly/networking/puis/ch08_06.htm
  it.returns "a cryptographic hash of self by applying the UNIX crypt algorithm with the specified salt" do
    "".crypt("aa").should_equal("aaQSqAReePlq6")
    "nutmeg".crypt("Mi").should_equal("MiqkFWCm1fNJI")
    "ellen1".crypt("ri").should_equal("ri79kNd7V6.Sk")
    "Sharon".crypt("./").should_equal("./UY9Q7TvYJDg")
    "norahs".crypt("am").should_equal("amfIADT2iqjA.")
    "norahs".crypt("7a").should_equal("7azfT5tIdyh0I")
    
    # Only uses first 8 chars of string
    "01234567".crypt("aa").should_equal("aa4c4gpuvCkSE")
    "012345678".crypt("aa").should_equal("aa4c4gpuvCkSE")
    "0123456789".crypt("aa").should_equal("aa4c4gpuvCkSE")
    
    # Only uses first 2 chars of salt
    "hello world".crypt("aa").should_equal("aayPz4hyPS1wI")
    "hello world".crypt("aab").should_equal("aayPz4hyPS1wI")
    "hello world".crypt("aabc").should_equal("aayPz4hyPS1wI")
  end
  
  it.raises " an ArgumentError when the salt is shorter than two characters" do
    lambda { "hello".crypt("")  }.should_raise(ArgumentError)
    lambda { "hello".crypt("f") }.should_raise(ArgumentError)
  end

  it.can "convert the salt arg to a string via to_str" do
    obj = mock('aa')
    def obj.to_str() "aa" end
    
    "".crypt(obj).should_equal("aaQSqAReePlq6")

    obj = mock('aa')
    obj.should_receive(:respond_to?).with(:to_str).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_str).and_return("aa")
    "".crypt(obj).should_equal("aaQSqAReePlq6")
  end

  it.raises " a type error when the salt arg can't be converted to a string" do
    lambda { "".crypt(5)         }.should_raise(TypeError)
    lambda { "".crypt(mock('x')) }.should_raise(TypeError)
  end
  
  it.will "taint the result if either salt or self is tainted" do
    tainted_salt = "aa"
    tainted_str = "hello"
    
    tainted_salt.taint
    tainted_str.taint
    
    "hello".crypt("aa").tainted?.should_equal(false)
    tainted_str.crypt("aa").tainted?.should_equal(true)
    "hello".crypt(tainted_salt).tainted?.should_equal(true)
    tainted_str.crypt(tainted_salt).tainted?.should_equal(true)
  end
  
  it.does_not " return subclass instances" do
    StringSpecs::MyString.new("hello").crypt("aa").class.should_equal(String)
    "hello".crypt(StringSpecs::MyString.new("aa")).class.should_equal(String)
    StringSpecs::MyString.new("hello").crypt(StringSpecs::MyString.new("aa")).class.should_equal(String)
  end
end
