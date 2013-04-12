#!/usr/bin/perl -w

open GOLD, "< ../comparison/attacca-gold-standard.xml";
open LEAVES, "> ../comparison/cassarray_leaves-unique";

my @gold = <GOLD>;
my %leaves = ();
my $previousLine = "";
my $currentLine ="";

for(my $index=0;$index < scalar(@gold);$index++) {
	$previousLine = $currentLine;
	$currentLine = $gold[$index];
	if($currentLine =~ m/\<name\>CassArray\<\/name\>/) {
		my $currentTab = 0;
		my $previousTab = 0;
		if($previousLine =~ m/^(\t*)/) { $previousTab = length($1); }
		if($currentLine =~ m/^(\t*)/) { $currentTab = length($1); }
		my $tempIndex = $index + 1;
		my $tempCurrLine = "";
		my $tempNextLine = "";
		my $tempCurrTab = 0;
		my $tempNextTab = 0;
		while($tempIndex < scalar(@gold)) {
			$tempCurrLine = $gold[$tempIndex];
			for(my $nextIndex=$tempIndex+1;$nextIndex < scalar(@gold);$nextIndex++) {
				if($gold[$nextIndex] =~ m/\<name\>(.+)\<\/name\>/) {
					$tempNextLine = $gold[$nextIndex];
					last;
				}
			}
			$tempCurrTab = 0;
			$tempNextTab = 0;
			if($tempCurrLine =~ m/^(\t*)/) { $tempCurrTab = length($1); }
			if($tempNextLine =~ m/^(\t*)/) { $tempNextTab = length($1); }
			if($tempCurrTab == $previousTab) { last; }
			if($tempCurrLine =~ m/\<name\>(.+)\<\/name\>/) {
				my $leaf = $1;
				if($tempNextTab < $tempCurrTab) {
					if(exists $leaves{$leaf}) {
						$leaves{$leaf}++;
					} else {
						$leaves{$leaf} = 1;
					}
				}
			}
			$tempIndex++;
		}
	}	
}

close GOLD;

foreach my $item (sort {$leaves{$b} <=> $leaves{$a}} keys %leaves) {
#	my $count = 0;
#	while($count < $leaves{$item}) {
		print LEAVES "$item\n";
#		$count++;
#	}
}

close LEAVES;
