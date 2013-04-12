#!/usr/bin/perl -w

open FILE1, "<missed1";
open FILE2, "<missed2";
open FILE3, "<missed3";
open FILE4, "<missed4";
open FILE5, "<missed5";
open FILE6, "<missed6";
open FILE7, "<missed7";
open FILE8, "<missed8";
open FILE9, "<missed9";
open FILE10, "<missed10";
 
open OUT, ">common";
my %hash = ();
my @common = ();
foreach my $line(<FILE1>) { 
	if($hash{$line}) { 
		$hash{$line}++;
	} else { 
		$hash{$line} = 1; 
	} 
}
foreach my $line(<FILE2>) { 
	if($hash{$line}) { 
		$hash{$line}++;
	} else { 
		$hash{$line} = 1; 
	} 
}
foreach my $line(<FILE3>) { 
	if($hash{$line}) { 
		$hash{$line}++;
	} else { 
		$hash{$line} = 1; 
	} 
}
foreach my $line(<FILE4>) { 
	if($hash{$line}) { 
		$hash{$line}++;
	} else { 
		$hash{$line} = 1; 
	} 
}
foreach my $line(<FILE5>) { 
	if($hash{$line}) { 
		$hash{$line}++;
	} else { 
		$hash{$line} = 1; 
	} 
}
foreach my $line(<FILE6>) { 
	if($hash{$line}) { 
		$hash{$line}++;
	} else { 
		$hash{$line} = 1; 
	} 
}
foreach my $line(<FILE7>) { 
	if($hash{$line}) { 
		$hash{$line}++;
	} else { 
		$hash{$line} = 1; 
	} 
}
foreach my $line(<FILE8>) { 
	if($hash{$line}) { 
		$hash{$line}++;
	} else { 
		$hash{$line} = 1; 
	} 
}
foreach my $line(<FILE9>) { 
	if($hash{$line}) { 
		$hash{$line}++;
	} else { 
		$hash{$line} = 1; 
	} 
}
foreach my $line(<FILE10>) { 
	if($hash{$line}) { 
		$hash{$line}++;
	} else { 
		$hash{$line} = 1; 
	} 
}

foreach my $key(keys %hash) { push(@common, $key) if $hash{$key} == 10; }
foreach my $item(sort @common) { print OUT "$item"; }
