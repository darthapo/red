describe :regexp_quote, :shared => true do
  it.can "escapes any characters with special meaning in a regular expression" do
    Regexp.send(@method, '\*?{}.+^[]()- ').should_equal('\\\\\*\?\{\}\.\+\^\[\]\(\)\-\\ ')
    Regexp.send(@method, "\*?{}.+^[]()- ").should_equal('\\*\\?\\{\\}\\.\\+\\^\\[\\]\\(\\)\\-\\ ')
    Regexp.send(@method, '\n\r\f\t').should_equal('\\\\n\\\\r\\\\f\\\\t')
    Regexp.send(@method, "\n\r\f\t").should_equal('\\n\\r\\f\\t')
  end
end
