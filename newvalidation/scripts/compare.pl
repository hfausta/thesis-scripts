#!/usr/bin/perl -w

open ANNOTATIONS, "< ../comparison/annotations-unique/$ARGV[0]_annotations";
open SPS, "< ../comparison/wdetails-unique/$ARGV[0]_details";
open GOLD, "< ../comparison/cassarray_leaves-unique";

my $truePositive = 0;
my $trueNegative = 0;
my $falsePositive = 0;
my $falseNegative = 0;
my $existGold = 0;
my $existSPS = 0;

my @annotations = <ANNOTATIONS>;
my @sps = <SPS>;
my @gold = <GOLD>;

foreach my $annotation(@annotations) {
	$existGold = 0;
	$existSPS = 0;
	chomp $annotation;
	foreach my $goldAnnotation(@gold) {
		chomp $goldAnnotation;
		if($goldAnnotation =~ m/$annotation/) { $existGold = 1; }	
	}
	foreach my $spsAnnotation(@sps) {
		chomp $spsAnnotation;
		if($spsAnnotation =~ m/$annotation/) { $existSPS = 1; } 
	}
	if($existGold == 1) {
		if($existSPS == 1) {
			$truePositive++;
		} else {
			$falseNegative++;
		}
	} else {
		if($existSPS == 1) {
			$falsePositive++;
		} else {
			$trueNegative++;
		}
	}
}

my $sensitivity = $truePositive/($truePositive+$falseNegative);
my $specificity = $trueNegative/($trueNegative+$falsePositive);
my $ppv = $truePositive/($truePositive+$falsePositive);

open RESULT, "> ../comparison/calculation-unique/$ARGV[0]_result";

print RESULT "$ARGV[0]\n";
print RESULT "True Positive = $truePositive\n";
print RESULT "True Negative = $trueNegative\n";
print RESULT "False Positive = $falsePositive\n";
print RESULT "False Negative = $falseNegative\n";
print RESULT "Sensitivity = $sensitivity\n";
print RESULT "Specificity = $specificity\n";
print RESULT "PPV = $ppv\n";

close RESULT;
