#!/usr/bin/perl -w

@files = <$ARGV[0]/*>;

foreach $file(@files) {

	open FILE, "<$file";
	open NEW, ">$file.ar";

	my $name = "";
	my @fileSplit = split('/', $file);
	$name = $fileSplit[@fileSplit-1];

	print NEW "name $name;\n";
	print NEW "%%\n\n";

	foreach my $line(<FILE>) {
		#$line =~ s/^0\s+(.+)\s+$/$1\;/;
		chomp $line;
		$line =~ m/\=\s{1}\(epsilon/ ?  $line =~ s/\((.+)\)/$1\,/ : $line =~ s/(\=\s{1}S\d+)\s{1}/$1\, /;
		$line =~ s/nil\-match/\`nil\-match\`/g;
		print NEW "$line\;\n";
	}

	close FILE;
	close NEW;
}

