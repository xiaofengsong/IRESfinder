#!/usr/bin/perl

use warnings;
use strict;

my $input = shift @ARGV;
my $output = '>' . shift @ARGV;
my $outlab = '>' . shift @ARGV;
my $ws	= shift @ARGV;
my $step  = shift @ARGV;

open(ID,$input) || die "$!";
open(OUT,$output) || die "$!";
open(LAB,$outlab) || die "$!";
my $id;
while(<ID>){
	if (/^>/){
		$id = $_;
		chomp $id;
		$id =~ s/>//;
	} else {
		my $str = $_;
		chomp $str;
		my $len = length($str);
		if ($len > 5){
			if ($len <= $ws) {
				print LAB $id,"\n";
				print OUT $str,"\n";
			} else {
				my $st = 0;
				my $m = 0;
				while ($st + $ws < $len){
					my $wd = substr($str,$st,$ws);
					print LAB $id,"_";
					print LAB $st+1,"_";
					print LAB $st+$ws,"\n";
					print OUT $wd,"\n";
					$st = $st + $step;
					$m++;
				}
				$st = $len - $ws;
				my $wd = substr($str,$st,$ws);
        		        print LAB $id,"_";
				print LAB $st+1,"_";
				print LAB $len,"\n";
        		        print OUT $wd,"\n";
			}
		}
	}

}
close(ID);
close(OUT);
close(LAB);
exit;
