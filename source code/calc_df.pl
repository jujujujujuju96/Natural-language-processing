#!/usr/bin/perl
#

&load_file;
&calc_df;
&print_dat;

sub load_file{

#    open(DFLOG, ">> /mkyozai/jk1sum/log/calc_df.log");
#    `date >> /mkyozai/jk1sum/log/calc_df.log`;
#    `whoami >> /mkyozai/jk1sum/log/calc_df.log`;
#    print DFLOG "perl calc_df.pl $ARGV[0] $ARGV[1] $ARGV[2] $ARGV[3]\n---\n";
#    close(DFLOG);

    #---load tf file to count df values---#
    $fname=$ARGV[0];
    @word=();
    open(FP,$fname)||die "cannot open $fname\n";
    while(defined($line=<FP>)){
        chomp($line);
	($tmp_word,$tmp_pos,$tmp_tf)=split(/\t/,$line);
	if($tmp_word ne ""){
	    push(@word,$tmp_word);
	    push(@pos,$tmp_pos);
	    push(@tf,$tmp_tf);
	}
    }
    close(FP);
    for($i=0; $i<= $#word; $i++){$dfcount[$i]=0;}
}

sub calc_df{
    $fnum=1;
    #---compare each elements of @df_dic with @word---#
    $dir_name=$ARGV[1];
    opendir(DIR,"$dir_name")||die("cannot open $dir_name");
    # print"$dir_name/\n";#check
    while($file_name=readdir(DIR)){
	if($file_name!~/^\.{1,2}/){ #not read ".", ".." files
	    #print "\t"."$file_name\n";#check
	    open(TF, "<$dir_name/$file_name")||die("cannot open $file_name\n");
	    print "open file $dir_name/$file_name ($fnum)\n";
	    $fnum++;

	    @dfword=();
	    while(defined($line=<TF>)){
		chomp($line);
		$tmp_word="";
		$tmp_pos="";
		($tmp_word,$tmp_pos,$tmp_tf)=split(/\t/,$line);

		for($i=0; $i<= $#word; $i++){
		    if($word[$i] eq $tmp_word && $pos[$i] eq $tmp_pos){
			$dfcount[$i]++;
#			print "$word[$i]\t$pos[$i]\t$file_name ($dfcount[$i])\n";
		    }
		}
	    }
	    close(TF);
	}
    }
}

sub print_dat{

    ($fname,$tmp)=split(/.tf/,$ARGV[0]);
    $fname=$fname.".df";
#    print "output file=$fname\n";
    open(DF, ">$fname")||die("cannot open $fname\n");
    for($i=0; $i<= $#word; $i++){
	if($word[$i] ne ""){
	    print DF "$word[$i]\t$pos[$i]\t$tf[$i]\t$dfcount[$i]\n";
	}
    }
    close(DF);
}
