#!/usr/bin/perl

use warnings;
use strict;

my $input = shift @ARGV;
my $output = '>' . shift @ARGV;
my $outlab = '>' . shift @ARGV;

open(ID,$input) || die "$!";
open(OUT,$output) || die "$!";
open(LAB,$outlab) || die "$!";
while(<ID>){
	if (/^>/){
		my $id = $_;
		chomp $id;
		$id =~ s/>//;
		print LAB $id,"\n";
	} else {
		print OUT $_;
	}
}
close(ID);
close(OUT);
close(LAB);
exit;
