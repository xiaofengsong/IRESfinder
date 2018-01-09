#!/usr/bin/perl

use strict;
use warnings;

my $input = shift @ARGV;
my $output = '>' . shift @ARGV;
my @NT = split('','TCGA');

my @kmer = @NT;
my @mer = @NT;
my @NTT = (@NT,"[TCGA]");
my @NTN = @NTT;

my @tmp = ();
foreach (@NT){
	my $add = $_;
        foreach (@mer){
        	my $str = $_ . $add;
                push(@tmp,$str);
        }
}
@mer = @tmp;
push(@kmer,@mer);

for (my $i = 3;$i < 6;$i++){
	foreach (@NT){
		my $add = $_;
			
		foreach (@NTN){
			my $str = $add;
			$str = $add . $_;
			foreach (@NT){
				my $str2 = $str;
				$str2 = $str . $_;
				push(@kmer,$str2);
			}			
		}

	}
	my @tmp;
	foreach (@NTN){
		my $str = $_;
		foreach (@NTT){
		 	my $tmp = $str;
			$tmp .= $_;
			push(@tmp,$tmp);
		}	
	}
	@NTN = @tmp;
	
}

#foreach (@kmer){
#	print $_,"\n";
#}
#exit;
open(ID,$input) || die "$!";
open(OUT,$output) || die "$!";
while(<ID>){
	my $str = $_;
	chomp $str;
	$str =~ tr/tcga/TCGA/;
	my $n = 0;
	foreach (@kmer){
		if ($_ !~ /\[/){
			$n ++;
			my $num = ($str =~ s/$_/$_/g);
			if (!$num){
				$num = 0;
			}
			my $len = length($_);
			my $feq = $num/(length($str)-$len+1);
			print OUT $feq,"\t";
		} else {
			my $f = $_;
			$n ++;
			my $len;
			if ($n > 20 && $n < 101){
				$len = 3;
			} elsif ($n < 501){
				$len = 4;
			} else {
				$len = 5;
			}
			my $end = length($str) - $len;
			my $num = 0;
			for (my $i = 0; $i <= $end; $i++){
				my $ss = substr($str,$i,$len);
				if ($ss =~ /$f/){
					$num++;
				}
			}
			my $feq = $num/(length($str)-$len+1);
			print OUT $feq,"\t";
		}
	}
	print OUT "\n";
}

close(ID);
close(OUT);
exit;
