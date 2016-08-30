#!/usr/bin/perl -w

use warnings;
use strict;

use Getopt::Long;
use Data::Dumper;
$Data::Dumper::Indent = 1;
$|=1;


# read input
my $inFile = shift || die "Please point to the correct verilog model\n\n";
unless(-e $inFile) {
	die "$inFile doesn't exist.\n\n";
}

# output directory cleanup
`mkdir -p ./mutation_testing/mutants`;
`mkdir -p ./mutation_testing/mutated_models`;
`rm -f ./mutation_testing/mutants/*`;
`rm -f ./mutation_testing/mutated_models/*`;


my $OUTDIR = "mutation_testing/mutants";

# extract module name
$inFile =~ /([^\/]+)\.v/;
our $module = $1;

print "Module: $module\n";

my @relOps = ('==', '!=', '<', '>');

my @boolOps = ('&&', '\|\|');

my @mathOps = ('\+','\-');

open FILE, "<$inFile" or die $!;

# Iterate through each line of the file
my $mline;
my $mutantID=0;
my $lineCount=0;
while(my $line = <FILE>){
	$lineCount++;
	next if($line=~/^\s*\/\//);
	next if($line=~/^\s*Ph\./);
	next if($line=~/^\s*E\-Mail/);
	next if($line=~/^\s*Fax/);

	if($line=~/if\s*\(.+\)/){
		# Boolean Logical Mutation : negation
		if($line=~/!/){
			$mline = $line;
			$mline =~ s/!//;

			writeMutant($line, $mline, $mutantID, $lineCount);
			$mutantID++;
		}


		# Boolean Logical Mutation
		if($line=~/&&/ || $line=~/\|\|/){
			my @caught = grep {$line=~/$_/} @boolOps;

			foreach my $old (@caught){
				foreach my $new (@boolOps){
					next if ($new eq $old);

					$mline = $line;
					my $tnew = $new;
					$tnew =~ s/\\//g;
					$mline =~ s/$old/$tnew/;
					# print "<$line>$mline |$old|$tnew|\n";
					writeMutant($line, $mline, $mutantID, $lineCount);
					$mutantID++;
				}
			}
		}
		

		# Boolean Relational Mutation
		if($line =~ /[<>=!]=?/){
			my @caught = grep {$line=~/$_/} @relOps;

			foreach my $old (@caught){
				foreach my $new (@relOps){
					next if ($new eq $old);

					$mline = $line;
					$mline =~ s/$old=?/$new/;
					# print "<$line>$mline |$old|$new|\n";
					writeMutant($line, $mline, $mutantID, $lineCount);
					$mutantID++;
				}
			}
		}
	}

	# Boolean Arithmetic Mutation
	if($line=~/[\+\-]/){
		my @caught = grep {$line=~/$_/} @mathOps;

		foreach my $old (@caught){
			foreach my $new (@mathOps){
				next if ($new eq $old);

				$mline = $line;
				my $tnew = $new;
				$tnew =~ s/\\//;
				$mline =~ s/$old/$tnew/;
				# print "<$line>$mline |$old|$tnew|\n";
				writeMutant($line, $mline, $mutantID, $lineCount);
				$mutantID++;
			}
		}
	}
}


close FILE;

print "\nGenerated $mutantID mutants\n";



# ---------------------------------------
# Now proceed with creating creating mutated models
# foreach mutant, make a copy of the original verilog code, and apply the mutant patch
my $mID = 0;
while($mID < $mutantID){
	my $patchFile = $OUTDIR."/${module}_m$mID.diff";
	my $mutatedModel = "mutation_testing/mutated_models/${module}_m$mID.v";
	`cp $inFile $mutatedModel`;
	`patch $mutatedModel < $patchFile`;

	# last;
	$mID++;
}
print "Completed creation of mutated models";

# ---------------------------------------



print "\n\n";




# -----------------------------------------------------------------------------

sub writeMutant{
	my $oldLine = shift;
	my $newLine = shift;
	my $mID = shift;
	my $lncnt = shift;

	# write mutant into a file with the Normal Diff patch format
	open oFILE, ">$OUTDIR/${module}_m$mID.diff" or die $!;
	print oFILE "${lncnt}c${lncnt}\n";
	print oFILE "< $oldLine";
	print oFILE "---\n";
	print oFILE "> $newLine";
	close oFILE;
}