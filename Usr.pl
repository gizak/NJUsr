use LWP::UserAgent;

package Usr;

$URL_LOGIN='http://jwas3.nju.edu.cn:8080/jiaowu/login.do';
%LOGIN_TOKEN=('userName'=>'091270015','password'=>'azonips');

$ua=LWP::UserAgent->new;
$ua->agent($USER_AGENT);
$ua->cookie_jar({});
%default_headers=(
	'Accept'=>'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
	'Accept-Charset'=>'UTF-8,*;q=0.5',
	'Accept-Encoding'=>'gzip,deflate,sdch',
	'Accept-Language'=>'en-US,en;q=0.8',
	'Connection'=>'keep-alive');
while (($k,$v)=each %default_headers){ $ua->default_header($k=>$v) }

sub login{
	print 'userName:'; chomp ($LOGIN_TOKEN{userName}= <STDIN>);
	print 'password:'; chomp ($LOGIN_TOKEN{password}= <STDIN>);
	($ua->post($URL_LOGIN,\%LOGIN_TOKEN)->content)=~/<div id="UserInfo">/;
}

sub default_login{
	($ua->post($URL_LOGIN,\%LOGIN_TOKEN)->content)=~/<div id="UserInfo">/;
}

1;
