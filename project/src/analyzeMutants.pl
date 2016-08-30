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

# extract module name
$inFile =~ /([^\/]+)\.v/;
our $module = $1;

print "Module: $module\n";

# output directory cleanup
`mkdir -p ./mutation_testing/m_obj_dir`;
`mkdir -p ./mutation_testing/m_out`;
`rm -f ./mutation_testing/m_obj_dir/*`;
`rm -f ./mutation_testing/m_out/*`;


my @items = `ls mutation_testing/mutants/*diff | wc -l`;
chomp @items;
my $numMutants = $items[0];


# ---------------------------------------
print "$numMutants mutants\n";
print "Generating ouput for each mutated model\n";

my @testbench = `ls tests/*${module}*`;
chomp @testbench;


my $mID = 0;
while($mID < $numMutants){
	my $mutatedModel = "mutation_testing/mutated_models/${module}_m$mID.v";
	print "\n\nWorking on [$mutatedModel]\n";

	# compile the mutated model
	`rm -f ./mutation_testing/m_obj_dir/*`;
	print `make buildTestModel VMOD_SRC=$mutatedModel MODULE_DIR=mutation_testing/m_obj_dir`;
	
	# build the testing object with the mutated model
	print `make buildtester MODULE_DIR=mutation_testing/m_obj_dir`;
	
	# run it on each testbench
	my $i=0;
	foreach (@testbench){
		`./runtest $_ > mutation_testing/m_out/temp$i.log`;
		$i++;
		print ".";
	}

	# merge outputs into one file
	open oFILE, ">mutation_testing/m_out/${module}_m${mID}.log" or die $!;
	foreach $i (0..$#testbench){
		open FILE, "<mutation_testing/m_out/temp$i.log" or die $!;

		while(<FILE>){
			if($_=~/OUTPUT/){
				while(<FILE>){
					last if $_=~/^$/;
					print oFILE $_;
				}
				last;
			}
		}

		close FILE;
	}
	close oFILE;

	$mID++;

	# last;
}


# ---------------------------------------
# rebuild golden tester and golden output
print "\n\n\nWorking on golden [$module] \n";
print `make buildtester`;
my $i=0;
foreach (@testbench){
	`./runtest $_ > mutation_testing/m_out/temp$i.log`;
	$i++;
	print ".";
}
# merge outputs into one file
open oFILE, ">${module}_golden.log" or die $!;
foreach $i (0..$#testbench){
	open FILE, "<mutation_testing/m_out/temp$i.log" or die $!;

	while(<FILE>){
		if($_=~/OUTPUT/){
			while(<FILE>){
				last if $_=~/^$/;
				print oFILE $_;
			}
			last;
		}
	}

	close FILE;
}
close oFILE;

# cleanup
`rm mutation_testing/m_out/temp*.log`;


# ---------------------------------------
# Finally, analysis
my $mutantsKilled = 0;
my $mutantScore = 0;

print "\n\nANALYSIS\n";
$mID = 0;
while($mID < $numMutants){
	print "mutant-$mID: ";
	if(`diff ${module}_golden.log mutation_testing/m_out/${module}_m${mID}.log`){
		print "PASS";
		$mutantsKilled++;
	} else {
		print "FAIL";
	}
	print "\n";

	$mID++;
}

$mutantScore = $mutantsKilled/$numMutants;

print "\n\nREPORT\n";
print "Number of Mutants: $numMutants\n";
print "Number of Mutants Killed: $mutantsKilled\n";
print "Mutation Score = $mutantScore\n";

print "\n\n";