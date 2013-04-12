#!/usr/bin/perl -w

open GRAMMAR, "< ../ar/$ARGV[0].ar";
open XML, "< ../xml/$ARGV[0].xml";
open WDETAIL, "> ../comparison/wdetails-unique/$ARGV[0]_details";
open WHISTOGRAM, "> ../comparison/histogram/$ARGV[0]_histogram";
open ANNOTATION, "> ../comparison/annotations-unique/$ARGV[0]_annotations";

my %generatedSymbol = ();
my %symbolLeafCount = ();
my %leafAnnotation = ();

#Get all the symbols in the generated grammar
foreach my $line(<GRAMMAR>) {
	if($line =~ m/(.+)\s+\:\:\=/) {
		my $symbol = $1;
		$symbol =~ s/^\s+//;
		$symbol =~ s/\s+$//;
		$generatedSymbol{$symbol} = {};
		$symbolLeafCount{$symbol} = 0;
	}
}

close GRAMMAR;

my $previousLine = "";
my $currentLine = "";
my @xml = <XML>;

for(my $index=0;$index < scalar(@xml);$index++) {
	$previousLine = $currentLine;
	$currentLine = $xml[$index];
	if($currentLine =~ m/\<name\>(.+)\<\/name\>/) {
		my $foundSymbol = $1;
		$foundSymbol =~ s/^\s+//;
		$foundSymbol =~ s/\s+$//;
		if(exists $generatedSymbol{$foundSymbol}) {
			my $currentTab = 0;
			my $previousTab = 0;
			if($previousLine =~ m/^(\t*)/) { $previousTab = length($1); }
			if($currentLine =~ m/^(\t*)/) { $currentTab = length($1); }
			my $tempIndex = $index + 1;
			my $tempCurrLine = "";
			my $tempNextLine = "";
			my $tempCurrTab = 0;
			my $tempNextTab = 0;
			while($tempIndex < scalar(@xml)) {	
				$tempCurrLine = $xml[$tempIndex];
				for(my $nextIndex=$tempIndex+1;$nextIndex < scalar(@gold);$nextIndex++) {
					if($gold[$nextIndex] =~ m/\<name\>(.+)\<\/name\>/) {
						$tempNextLine = $gold[$nextIndex];
					}
				}
				if($tempCurrLine =~ m/^(\t*)/) { $tempCurrTab = length($1); }
				if($tempNextLine =~ m/^(\t*)/) { $tempNextTab = length($1); }
				if($tempCurrTab == $previousTab) { last; }
				if($tempCurrLine =~ m/\<name\>(.+)\<\/name\>/) {
					my $leaf = $1;
					if($tempNextTab < $tempCurrTab) {
						if(exists $generatedSymbol{$foundSymbol}{$leaf}) {
							$generatedSymbol{$foundSymbol}{$leaf}++;
						} else {
							$generatedSymbol{$foundSymbol}{$leaf} = 1;
						}
						$symbolLeafCount{$foundSymbol}++;	
					}	
				}
				$tempIndex++;
			}
		} else {
			if(exists $leafAnnotation{$foundSymbol}) {
				$leafAnnotation{$foundSymbol}++;
			} else {
				$leafAnnotation{$foundSymbol} = 1;
			}			
		}
	}
}

close XML;

my $numSPS = 0;
foreach my $root (sort {$symbolLeafCount{$b} <=> $symbolLeafCount{$a}} keys %generatedSymbol) {
	if($numSPS < 2) {
		print WDETAIL "<sps>\n";
		print WDETAIL "\t<name>$root</name>\n";
		foreach my $leaf(keys %{$generatedSymbol{$root}}) {
#			my $count = 0;
#			while($count < $generatedSymbol{$root}{$leaf}) {
				print WDETAIL "\t\t<annotation>$leaf</annotation>\n";
#				$count++;
#			}
		}
		print WDETAIL "</sps>\n";
		$numSPS++;
	} else {
		last;
	}
}

close WDETAIL;

foreach my $root (sort {$symbolLeafCount{$b} <=> $symbolLeafCount{$a}} keys %symbolLeafCount) {
	print WHISTOGRAM "$root: $symbolLeafCount{$root} leaves\n";
}

close WHISTOGRAM;

foreach my $annotation (sort keys %leafAnnotation) {
#	my $count = 0;
#	while($count < $leafAnnotation{$annotation}) {
		print ANNOTATION "$annotation\n";
#		$count++;
#	}
}

close ANNOTATION;
