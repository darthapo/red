# require File.dirname(__FILE__) + '/../spec_helper'

# Thanks http://www.zenspider.com/Languages/Ruby/QuickRef.html

describe "Ruby character strings" do |it| 

  it.before(:each) do
    @ip = 'xxx' # used for interpolation
  end

  it.can "don't get interpolated when put in single quotes" do
    '#{@ip}'.should_equal('#{@ip}')
  end

  it 'get interpolated with #{} when put in double quotes' do
    "#{@ip}".should_equal('xxx')
  end

  it.can "interpolate instance variables just with the # character" do
    "#@ip".should_equal('xxx')
  end

  it.can "interpolate global variables just with the # character" do
    $ip = 'xxx'
    "#$ip".should_equal('xxx')
  end

  it.can "interpolate class variables just with the # character" do
    @@ip = 'xxx'
    "#@@ip".should_equal('xxx')
  end

  it.can "allow underscore as part of a variable name in a simple interpolation" do
    @my_ip = 'xxx'
    "#@my_ip".should_equal('xxx')
  end

  it.can "have characters [.(=?!# end simple # interpolation" do
    "#@ip[".should_equal('xxx[')
    "#@ip.".should_equal('xxx.')
    "#@ip(".should_equal('xxx(')
    "#@ip=".should_equal('xxx=')
    "#@ip?".should_equal('xxx?')
    "#@ip!".should_equal('xxx!')
    "#@ip#@ip".should_equal('xxxxxx')
  end

  it.can "allow using non-alnum characters as string delimiters" do
    %(hey #{@ip}).should_equal("hey xxx")
    %[hey #{@ip}].should_equal("hey xxx")
    %{hey #{@ip}}.should_equal("hey xxx")
    %<hey #{@ip}>.should_equal("hey xxx")
    %!hey #{@ip}!.should_equal("hey xxx")
    %@hey #{@ip}@.should_equal("hey xxx")
    %#hey hey#.should_equal("hey hey")
    %%hey #{@ip}%.should_equal("hey xxx")
    %^hey #{@ip}^.should_equal("hey xxx")
    %&hey #{@ip}&.should_equal("hey xxx")
    %*hey #{@ip}*.should_equal("hey xxx")
    %-hey #{@ip}-.should_equal("hey xxx")
    %_hey #{@ip}_.should_equal("hey xxx")
    %=hey #{@ip}=.should_equal("hey xxx")
    %+hey #{@ip}+.should_equal("hey xxx")
    %~hey #{@ip}~.should_equal("hey xxx")
    %:hey #{@ip}:.should_equal("hey xxx")
    %;hey #{@ip};.should_equal("hey xxx")
    %"hey #{@ip}".should_equal("hey xxx")
    %|hey #{@ip}|.should_equal("hey xxx")
    %?hey #{@ip}?.should_equal("hey xxx")
    %/hey #{@ip}/.should_equal("hey xxx")
    %,hey #{@ip},.should_equal("hey xxx")
    %.hey #{@ip}..should_equal("hey xxx")
    
    # surprised? huh
    %'hey #{@ip}'.should_equal("hey xxx")
    %\hey #{@ip}\.should_equal("hey xxx")
    %`hey #{@ip}`.should_equal("hey xxx")
    %$hey #{@ip}$.should_equal("hey xxx")
  end

  it.can "using percent with 'q', stopping interpolation" do
    %q(#{@ip}).should_equal('#{@ip}')
  end

  it.can "using percent with 'Q' to interpolate" do
    %Q(#{@ip}).should_equal('xxx')
  end

  # The backslashes :
  #
  # \t (tab), \n (newline), \r (carriage return), \f (form feed), \b
  # (backspace), \a (bell), \e (escape), \s (whitespace), \nnn (octal),
  # \xnn (hexadecimal), \cx (control x), \C-x (control x), \M-x (meta x),
  # \M-\C-x (meta control x)
  
  it.can "backslashes follow the same rules as interpolation" do
    "\t\n\r\f\b\a\e\s\075\x62\cx".should_equal("\t\n\r\f\b\a\e =b\030")
    '\t\n\r\f\b\a\e =b\030'.should_equal("\\t\\n\\r\\f\\b\\a\\e =b\\030")
  end

  it.can "allow HEREDOC with <<identifier, interpolated" do
    s = <<HERE
foo bar#{@ip}
HERE
    s.should_equal("foo barxxx\n")
  end
  
  it 'allow HEREDOC with <<"identifier", interpolated' do
    s = <<"HERE"
foo bar#{@ip}
HERE
    s.should_equal("foo barxxx\n")
  end

  it.can "allow HEREDOC with <<'identifier', no interpolation" do
    s = <<'HERE'
foo bar#{@ip}
HERE
    s.should_equal('foo bar#{@ip}' + "\n")
  end
  
  it.can "allow HEREDOC with <<-identifier, allowing to indent identifier, interpolated" do
    s = <<-HERE
    foo bar#{@ip}
    HERE

    s.should_equal("    foo barxxx\n")
  end
  
  it 'allow HEREDOC with <<-"identifier", allowing to indent identifier, interpolated' do
    s = <<-"HERE"
    foo bar#{@ip}
    HERE

    s.should_equal("    foo barxxx\n")
  end
  
  it.can "allow HEREDOC with <<-'identifier', allowing to indent identifier, no interpolation" do
    s = <<-'HERE'
    foo bar#{@ip}
    HERE

    s.should_equal('    foo bar#{@ip}' + "\n")
  end

end
