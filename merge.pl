#!/usr/bin/perl -w

open BASE, "<new"; #open the base grammar file
open NEW, "<base"; #open the new grammar file
my %baseHash = (); #stores the base grammar, Key = the relations, Value = the State
my @newGrammar = (); #stores the new grammar
my $baseNext = "S0";
my $newNext = "S0";
my $currIndex = 0;
my $prevIndex = $currIndex;

#Take the data from the input files
foreach my $line(<BASE>) {
	$line =~ s/^\s+//;
	$line =~ s/\s+$//;
	my @keyValue = split(" ::= ", $line);
	$baseHash{$keyValue[1]} = $keyValue[0];
	if($keyValue[0] gt $baseNext) { 
		$baseNext = $keyValue[0]; 
	}
}
close BASE;

foreach my $line(<NEW>) {
	$line =~ s/^\s+//;
	$line =~ s/\s+$//;
	my @split = split(" ::= ", $line);
	if($split[0] gt $newNext) {
		$newNext = $split[0];
	}
	push(@newGrammar, $line);
}
close NEW;

foreach my $relation(@newGrammar) {
	my @keyValue = split(" ::= ", $relation);
	my $value = $keyValue[0];
	my $key = $keyValue[1];
	my @keySplit = split(" ", $key);
	#Check if the relation exists inside the base grammar
	if($baseHash{$key}) {
		if($baseHash{$key} ne $value) {
			$prevIndex = $currIndex;
			my $incrIndex = 1;
			while($currIndex < @newGrammar) {
				if(($newGrammar[$currIndex] =~ m/^$baseHash{$key}\s+/) or ($newGrammar[$currIndex] =~ m/\s+$baseHash{$key}\s+/)) {
					if($incrIndex == 1) {
						if($newNext =~ m/S(\d+)/) {
							my $next = $1 + 1;
							$newNext = S.$next;
							$incrIndex = 0;
						}
					}
					$newGrammar[$currIndex] =~ s/$baseHash{$key}/$newNext/g;	
				}	
				$newGrammar[$currIndex] =~ s/$value/$baseHash{$key}/g;
				$currIndex++;
			}
			$currIndex = $prevIndex++;
		}
	} else {
		#Add the new relation to the base grammar
		if($baseNext =~ m/S(\d+)/) {
			my $next = $1 + 1;
			$baseNext = S.$next;
		}
		$baseHash{$key} = $baseNext;
	}	
}

#Print out the results
foreach my $key(sort {$baseHash{$a} cmp $baseHash{$b}} keys %baseHash) {
	print "$baseHash{$key} ::= $key\n";
}
