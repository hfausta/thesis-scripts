#!/usr/bin/perl -w

open FILE, "<$ARGV[0]";
open CALCULATE, ">$ARGV[1]";

foreach my $line(<FILE>) {
	if($line =~ m/\-\>\s+(\d+)\:(\d+)\:(\d+)\s+\-\s+(\d+)\:(\d+)\:(\d+)\s+\-\>/) {
		$timeCalc = ($4*3600+$5*60+$6) - ($1*3600+$2*60+$3);
		$line =~ s/\-\>\s+(\d+)\:(\d+)\:(\d+)\s+\-\s+(\d+)\:(\d+)\:(\d+)\s+\-\>/\-\> $timeCalc s \-\>/;
	}
	if($line =~ m/\-\>\s+DiG\s+(\d+)\:(\d+)\:(\d+)\s+\-\s+(\d+)\:(\d+)\:(\d+)\s+\-\>/) {
		$timeCalc = ($4*3600+$5*60+$6) - ($1*3600+$2*60+$3);
		$line =~ s/\-\>\s+DiG\s+(.+)\-\>/\-\> DiG : $timeCalc s \-\>/;
	}
	print CALCULATE "$line\n";
}

close FILE;
close CALCULATE;
