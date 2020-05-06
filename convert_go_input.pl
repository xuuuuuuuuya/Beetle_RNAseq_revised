#!perl -wl

use strict;


my $usage = "Usage: perl convert_go_input.pl allgenelist immunegene delist\n";
my $allgenelist = $ARGV[0] or die  $usage;
my $immunegene  = $ARGV[1] or die $usage;
my $degene = $ARGV[2];


open (F1, $allgenelist ) ;
open (F2, $immunegene) ;
open (F3, $degene) ;
#open (OUT, ">", $outputFile) or die "Couldn't not write $outputFile: $!\n"; but in this case we only print and put it in another file



my %immu ;#read the immunegene file line by line and put it in a hash
while (<F2>){
my @row = split;
chomp;
my $onlycg = $row[1];
my $function = $row[2];
$immu{$onlycg} = $function;#hash key is the line in immunegene which contains only one column of immune genes, and hash value is 1(hash value does not matter)
}
close F2;

my %de ;#do the same to degene
while (<F3>){
my @row = split;
chomp;
my $onlyde = $row[0];
my $foldchange = $row[2];
$de{$onlyde} = $foldchange;
}
close F3;


while (<F1>){#finally the biggest file allgenelist, first row trinityid and 4th row cg iterm

my @row = split; 
my $curr_tri = $row[0];
my $curr_imm = $row[3];


my $has_tri = 0;
my $has_imm = 0;
my $has_function = " ";
my $has_foldchange = " ";

if ($immu{$curr_imm}){
	$has_imm = 1;
	$has_function = $immu{$curr_imm}
	}
	
else {
	$has_function = "NA";
}

	#test membership of hash key, in the hash ‰immu, if curr_imm exist in the key, assign $has_imm to 1
if ($de{$curr_tri}){
	$has_tri = 1;#same to the degenes
	$has_foldchange = $de{$curr_tri}
	}

else {
	$has_foldchange = "NA";
}

print ($row[0], "\t", $row[3], "\t",$has_imm, "\t", $has_tri, "\t", $has_function, "\t", $has_foldchange);#slightly different than perl


}



