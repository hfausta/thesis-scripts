#!/usr/bin/perl -w
use File::Copy;

my $fileIndex = 1;
my $reducerIndex = 1;
my $jarDirectory = $ARGV[0];
my $inputDirectory = $ARGV[1];
my $outputDirectory = $ARGV[2];

while($reducerIndex <= 4) {
	while($fileIndex <= 30) {
		my $newInputDirectory = $inputDirectory.$fileIndex;
		if($reducerIndex > 1) {
			my $overlap = 0;
			while($overlap < 110) {
				my @args = ("/usr/local/hadoop/bin/hadoop", "jar", $jarDirectory, "au.org.chi.DiGHadoop", "DiGHadoopR".$reducerIndex."T".$fileIndex."O".$overlap, $newInputDirectory, $outputDirectory, $reducerIndex, $reducerIndex, $overlap);
				system(@args);
				$overlap += 10;
			}
		} else {
			my @args = ("/usr/local/hadoop/bin/hadoop", "jar", $jarDirectory, "au.org.chi.DiGHadoop", "DiGHadoopR".$reducerIndex."T".$fileIndex, $newInputDirectory, $outputDirectory, $reducerIndex, $reducerIndex, 0);
			system(@args);
		}
		$fileIndex++;
	}
	$fileIndex = 1;
	$reducerIndex++;
}
