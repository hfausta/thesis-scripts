#!/usr/bin/perl -w

open GRAMMAR, "< ../ar/$ARGV[0].ar";
open XML, "< ../xml/$ARGV[0].xml";
open GOLD, "< ../comparison/attacca-gold-standard.xml";

my @grammar = <GRAMMAR>;
my @xml = <XML>;
my @gold = <GOLD>;

my %accessionSymbol = ();
my %accessionGold = ();
my %symbolLeafCount = ();

foreach my $line(<GRAMMAR>) {
	if($line =~ m/(.+)\s+\:\:\=/) {
		my $symbol = $1;
		$symbol =~ s/^\s+//;
		$symbol =~ s/\s+$//;
		$accessionSymbol{$symbol} = {};
		$symbolLeafCount{$symbol} = 0;
	}
}

close GRAMMAR;

my $previousLine = "";
my $currentLine = "";
my $accessionName = "";
my $currentTab = 0;
my $previousTab = 0;

for(my $index=0;$index < scalar(@xml);$index++) {
	$previousLine = $currentLine;
	$currentLine = $xml[$index];
	if($currentLine =~ m/\<name\>(.+)\<\/name\>/) {
		my $foundSymbol = $1;
		$foundSymbol =~ s/^\s+//;
		$foundSymbol =~ s/\s+$//;
		if($previousLine =~ m/\<accession\>/) {
			$accessionName = $foundSymbol;	
		}
		if($previousLine =~ m/^(\t*)/) { $previousTab = length($1); }
		if($currentLine =~ m/^(\t*)/) { $currentTab = length($1); }

		if(exists $accessionSymbol{$foundSymbol}) {
			my $tempIndex = $index+1;
			my $tempCurrLine = "";
			my $tempNextLine = "";
			while($tempIndex < scalar(@xml)) {
				$tempCurrLine = $xml[$tempIndex];
				for(my $nextIndex=$tempIndex+1;$nextIndex<scalar(@xml);$nextIndex++) {
					if($xml[$nextIndex] =~ m/\<name\>(.+)\<\/name\>/) {
						$tempNextLine = $xml[$nextIndex];
					}
				}
				if($tempCurrLine =~ m/^(\t*)/) { $tempCurrTab = length($1); }
				if($tempNextLine =~ m/^(\t*)/) { $tempNextTab = length($1); }
				if($tempCurrLine == $previousTab) { last; }
				if($tempCurrLine =~ m/\<name\>(.+)\<\/name\>/) {
					my $leaf = $1;
					if($tempNextTab <= $tempCurrTab) {
						if(exists $accessionSymbol{$foundSymbol}{$accessionName}{$leaf}) {
							$accessionSymbol{$foundSymbol}{$accessionName}{$leaf}++;
						} else {
							$accessionSymbol{$foundSymbol}{$accessionName}{$leaf} = 1;
						}
						$symbolLeafCount{$foundSymbol}++;
					}
				} elsif($tempCurrLine =~ m/\<nil\-match\>/) {
					if(exists $accessionSymbol{$foundSymbol}{$accessionName}{"nil-match"} {
						$accessionSymbol{$foundSymbol}{$accessionName}{"nil-match"}++;
					} else {
						$accessionSymbol{$foundSymbol}{$accessionName}{"nil-match"} = 1;
					}
					$symbolLeafCount{$foundSymbol}++;
				}
				$tempIndex++;
			}
		}
	}
}

my $two = 0;
my @sps = ();
foreach my $keys(sort {$symbolLeafCount{$b} <=> $symbolLeafCount{$a}} keys %symbolLeafCount) {
	if($two < 2) {
		push(@sps, $keys);
	}
	$two++;
}

$currentLine = "";
$previousLine = "";
$currentTab = 0;
$previousTab = 0;
for(my $index=0;$index<scalar(@gold);$index++) {
	$previousLine = $currLine;
	$currLine = $gold[$index];
	if($currentLine =~ m/\<name\>(.+)\/name\>/) {
		my $foundSymbol = $1;
		$foundSymbol =~ s/^\s+//;
		$foundSymbol =~ s/\s+$//;
		if($previousLine =~ m/\<accession\>/) {
			$accessionName = $foundSymbol;	
		}
		if($previousLine =~ m/^(\t*)/) { $previousTab = length($1); }
		if($currentLine =~ m/^(\t*)/) { $currentTab = length($1); }
		if($foundSymbol =~ m/CassArray\</) {
			my $tempIndex = $index + 1;
			
		}
	}
}
