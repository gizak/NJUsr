#!/usr/bin/perl

use Smart::Comments;

require 'Usr.pl';

package CrsSlc;


$USER_AGENT='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/25.0.1364.99 Safari/537.22';
$URL_SELECT_BASE='http://jwas3.nju.edu.cn:8080/jiaowu/student/elective/courseList.do?method=discussRenewCourseList&campus=';
$URL_CAMPUS_GL='%e9%bc%93%e6%a5%bc%e6%a0%a1%e5%8c%ba';
$URL_CAMPUS_XL='%E4%BB%99%E6%9E%97%E6%A0%A1%E5%8C%BA';
$URL_SUBMIT='http://jwas3.nju.edu.cn:8080/jiaowu/student/elective/courseList.do?method=submitDiscussRenew&campus=';


###config user agent...

while (!&Usr::login) {print "login failed\n"}

### login success!
print "\n".'select campus[01]... (0->GULOU, 1->XINLIN) ';
chomp ($_=<STDIN>);
$campus=$_;
$url=$URL_SELECT_BASE.($_?$URL_CAMPUS_XL:$URL_CAMPUS_GL);

$selected=undef;
sub search {
	$_=$Usr::ua->get($url)->content;
	foreach (/(?<=<tr class="TABLE_TR_0[12]">).*?(?=<\/tr>)/g){
		my @m=/(?<=<td valign="middle">)[^<]+(?=<\/td>)|(?<=<td align="center" valign="middle">)\w+|(?<=value=").*(?="><\/td>)/g;
		push @res_set,\@m;
	}
	foreach (@res_set) {
		my $flag = $_->[4]>0 ? -1 : 0; 
		if ($_->[5+$flag]>$_->[6+$flag]) {
			$selected=$_;
			return $_->[$#$_];
		}
	}
}

### [<now>]start processing, waiting...
while(!($cid=&search)) { ###Progressing... done
	sleep 1;
}
### $selected
### [<now>]submit...
$submit_url=$URL_SUBMIT.($campus?$URL_CAMPUS_XL:$URL_CAMPUS_GL).'&classId='.$cid;
### URL:$submit_url
$Usr::ua->get($submit_url);
### [<now>]submit completed...
