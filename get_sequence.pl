#! /usr/bin/perl -w

##########################################################################################
### Get GC Content                                                                               
### Usage: AssemblyFil.pl <fasta file>                                                        
### This program takes a fasta file as it's first (and only) parameter.                                                                                                   
##########################################################################################


use strict;

my $usage = "Usage: perl AssemblyFiltering.pl inputFile FilteredFile outputFile\n";
my $inputFile = $ARGV[0] or die  $usage;
my $FilteredFile  = $ARGV[1] or die $usage;
my $outputFile = $ARGV[2] or die $usage;

open (F1, $inputFile) or die "Couldn't open file $inputFile: $!\n";
open (F2, $FilteredFile) or die "Couldn't open file $FilteredFile: $!\n";
open (OUT, ">", $outputFile) or die "Couldn't not write $outputFile: $!\n";

my %filter;
my %hash;
my $dna="";
my $header;

while (<F2>) { 
    chomp; 
    $filter{$_}=""; 
} 

while (<F1>) {  	# read line by line
	chomp($_);  	# remove newlines
	if ($_ =~  m/(>)(.*$)/ ) {		# matchs header pattern ">"
		if ($dna ne "") {		# gets in only if $dna is not empty after matching ">"
			$hash{$header}=$dna;	# assign header to its dna sequence
			$dna = "";		# empty dna in order to start again
		}
    	$header = $2; 	# this catches the header 
	} 	
	else {		# concatenates lines that do not start with ">" until finding a new ">"
    	$dna .= $_; 
  	}
}

$hash{$header}=$dna;	# this is needed to add assign the dna sequence to its header


foreach $header (sort keys %hash) {
	my @words = split /\s+/, $header;
	print OUT ">$header\n$hash{$header}\n" if (exists ( $filter{"$words[0]"} ) ) ; 
}


