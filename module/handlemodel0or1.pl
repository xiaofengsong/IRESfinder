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
my $seq;
while(<ID>){
	if (/^>/){
		if (defined($seq)){
			$seq .= "\n";
			if ($st == 0 && $ed == 0){
                	        print OUT $seq;
                	} elsif ($st >= $ed){
	
        	                print OUT $seq;
	                } else {
	                        my $str = $seq;
	                        chomp $str;
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
		$seq = '';
		my $id = $_;
		chomp $id;
		$id =~ s/>//;
		my @wd = split(' ',$id);
		chomp @wd;
		my $m = @wd;
		print LAB join("_",@wd),"\n";
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
		$seq .= $_;
		chomp $seq;			
	}
}
if (defined($seq)){
        $seq .= "\n";
        if ($st == 0 && $ed == 0){
                print OUT $seq;
        } elsif ($st >= $ed){

                print OUT $seq;
        } else {
                my $str = $seq;
                chomp $str;
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
close(ID);
close(OUT);
close(LAB);
exit;
