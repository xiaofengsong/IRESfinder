#!/usr/bin/perl

use warnings;
use strict;

my $input = shift @ARGV;
my $output = '>' . shift @ARGV;
my $outlab = '>' . shift @ARGV;

open(ID,$input) || die "$!";
open(OUT,$output) || die "$!";
open(LAB,$outlab) || die "$!";
my $st = 0;
my $ed = 0;
my $lab;
while(<ID>){
	if (/^>/){
		my $id = $_;
		chomp $id;
		$id =~ s/>//;
		my @wd = split(' ',$id);
		chomp @wd;
		my $m = @wd;
		$lab = join("_",@wd);
#		print LAB join("_",@wd),"\n";
		if ($m >= 3){
			$ed = pop @wd;
			$st = pop @wd;

			if ($st =~ /[^0-9]/ || $ed =~ /[^0-9]/){
				$st = 0;
				$ed = 0;
			}
		} else {
			$st = 0;
			$ed = 0;
		}
	} else {
		my $str = $_;
		chomp $str;
		if (length($str) > 5){
			print LAB $lab,"\n";
			if ($st == 0 && $ed == 0){
				print OUT $_;
			} elsif ($st >= $ed){
				
				print OUT $_;
			} else {
#			my $str = $_;
#			chomp $str;
				$st = $st - 1;
				if ($ed <= length($str)){
					my $len = $ed - $st;
					print OUT substr($str,$st,$len),"\n";
				} else {
					$ed = length($str);
					my $len = $ed - $st;
	                                print OUT substr($str,$st,$len),"\n";
				}
			}
		} 
	}
}
close(ID);
close(OUT);
close(LAB);
exit;
