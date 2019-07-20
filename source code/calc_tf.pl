#!/usr/bin/perl
#
use Text::MeCab;

#    open(TFLOG, ">> /mkyozai/jk1sum/log/calc_tf.log");
#    `date >> /mkyozai/jk1sum/log/calc_tf.log`;
#    `whoami >> /mkyozai/jk1sum/log/calc_tf.log`;
#    print TFLOG "perl calc_tf.pl $ARGV[0] $ARGV[1] $ARGV[2] $ARGV[3]\n---\n";
#    close(TFLOG);
    
$in_file=$ARGV[0];
$out_file=$ARGV[0].".tf";
$mecab_file=$ARGV[0].".mecab";
print "input=$in_file  output=$out_file, $mecab_file\n";
    
open(TEXT, "$in_file")||die("cannot open $in_file\n");
$line="";
while(defined($line=<TEXT>)){
    chomp($line);
    push(@text,$line); 
}
close(TEXT);

open(FP, ">$mecab_file")||die("cannot open $mecab_file\n");

$tmp="";
foreach(@text){
    $m = Text::MeCab->new();
    $n = $m->parse($_);
    while($n){
	@ft = split(/,/,$n->feature);

#added by Ryosuke Yamanishi, June 4, 2016 from here
	if($ft[6] eq "*")
	{
	    $ft[6] = $n->surface;
	}	
#added by Ryosuke Yamanishi, June 4, 2016 by here

	$tmp = sprintf("%s\t%s,%s", $ft[6], $ft[0], $ft[1]);
	if(index($ft[0],"EOS")>0){
	    printf(FP "EOS\n");
	}
	else{
		printf(FP "%s\t%s\n", $n->surface, $tmp);

	}
	push(@mecab, $tmp);
	$n = $n->next;
    }
}
close(FP);

open(TF, ">$out_file")||die("cannot open $out_file\n");
foreach $value(@mecab){
    if($value=~/EOS/){ #skip EOS of mecab's result
	next;}
    $list{$value}++;
}

foreach(keys %list){
    print TF "$_\t$list{$_}\n";
}
close(TF);
