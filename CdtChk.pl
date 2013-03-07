#!/usr/perl

use Smart::Comments;
use HTML::TreeBuilder::XPath;

require 'Usr.pl';

package CdtChk;

$URL_SCORE_LIST='http://jwas3.nju.edu.cn:8080/jiaowu/student/studentinfo/achievementinfo.do?method=searchTermList';


### login...
while(!&Usr::login) {print 'login failed..'."\n"}
#&Usr::default_login;
### get content...

$_=$Usr::ua->get($URL_SCORE_LIST)->decoded_content;
### build parse tree...
my $tree=HTML::TreeBuilder::XPath->new;
$tree->parse($_);
@nodes=split "\n",($tree->findnodes_as_string("/html/body/div[2]/table//table")) ;
@term_code=$nodes[0] =~ /<a href="(.*?)">/g;
for (@term_code) { s/&amp;/&/;}
@term_name=$nodes[0] =~ /<tr align="center" .*?<a .*?">(.+?)<\/a>/g;

sub extract {
	$tree=pop;
	@records_raw=(split "\n",($tree->findnodes_as_string("/html/body/div[2]/table//table")))[1] =~ /<tr align="left" .+?>(.*?)<\/tr>/g;
	my @res_set;
	foreach (@records_raw) {
		my $tree=HTML::TreeBuilder::XPath->new;
		$tree->parse($_);
		push @res_set,[$tree->findvalues('//td')];
	}
	\@res_set;
}

my @shelf;
my @list;
### collecting...
for (@term_code) {  ### Evaluating [===|    ] % done
	my $url='http://jwas3.nju.edu.cn:8080/jiaowu/'.$_;
	$_=$Usr::ua->get($url)->decoded_content;
	my $tree=HTML::TreeBuilder::XPath->new;
	$tree->parse($_);
	push @shelf,&extract($tree);
	@list=(@list,@{&extract($tree)});
}
### eval...
my $count=0;
my $sum=0;
for (@list) {
	my $score=$_->[6];
	$score =~ s/^\s+//;
	$score =~ s/\s+$//;
	if ($score>60) {
		++$count;
		$sum+=$score;
	}
}

### $count
### avg:$sum/$count
